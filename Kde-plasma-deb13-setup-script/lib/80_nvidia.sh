#!/usr/bin/env bash
set -euo pipefail

purge_nvidia_stack() {
  run_step_allow_fail "Purge NVIDIA/CUDA (broad)" bash -lc "apt-get remove --autoremove --purge -y 'cuda-*' 'nvidia-*' 'libnvidia-*' 'xserver-xorg-video-nvidia*' || true"
  run_step_allow_fail "Remove DKMS leftovers" bash -lc "rm -rf /var/lib/dkms/nvidia* || true"
  run_step_allow_fail "Remove modprobe leftovers" bash -lc "rm -rf /etc/modprobe.d/nvidia* || true"
  run_step_allow_fail "Remove pinning leftovers" bash -lc "rm -rf /etc/apt/preferences.d/nvidia* || true"
  run_step_allow_fail "Remove NVIDIA repo list leftovers" bash -lc "rm -rf /etc/apt/sources.list.d/cuda* /etc/apt/sources.list.d/nvidia* || true"
  run_step_allow_fail "update-initramfs -u" update-initramfs -u
  safe_apt_recover
}

install_mok_tools() {
  pm_install_smart mokutil shim-signed sbsigntool
  run_step_allow_fail "mokutil --sb-state" mokutil --sb-state
}

enable_nvidia_repo_debian13() {
  local deb="cuda-keyring_1.1-1_all.deb"
  local url="https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/${deb}"
  run_step_allow_fail "Download cuda-keyring" bash -lc "rm -f '$deb' && wget -q '$url'"
  run_step_allow_fail "Install cuda-keyring" dpkg -i "$deb"
  run_step_allow_fail "apt-get update (after cuda-keyring)" apt-get update

  if ! apt-cache policy | grep -q 'developer.download.nvidia.com/compute/cuda/repos/debian13'; then
    warn "cuda-keyring didn't activate repo; applying manual repo entry."
    run_step_allow_fail "Download cuda-archive-keyring.gpg" bash -lc "wget -q https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-archive-keyring.gpg"
    run_step_allow_fail "Install cuda-archive-keyring.gpg" bash -lc "install -D -m 0644 cuda-archive-keyring.gpg /usr/share/keyrings/cuda-archive-keyring.gpg"
    run_step_allow_fail "Write NVIDIA repo list" bash -lc "echo 'deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/ /' > /etc/apt/sources.list.d/cuda-debian13-amd64.list"
    run_step_allow_fail "apt-get update (after manual repo add)" apt-get update
  else
    ok "NVIDIA repo visible in apt-cache policy."
  fi
}

install_nvidia_open_stack() {
  pkg_exists nvidia-driver-assistant && pm_install_smart nvidia-driver-assistant || true
  if command -v nvidia-driver-assistant >/dev/null 2>&1; then
    run_step_allow_fail "nvidia-driver-assistant" nvidia-driver-assistant
  fi

  pm_install_smart \
    nvidia-open \
    nvidia-kernel-open-dkms \
    nvidia-modprobe \
    nvidia-persistenced \
    nvidia-settings \
    nvidia-smi

  run_step_allow_fail "dkms autoinstall" dkms autoinstall
  run_step_allow_fail "update-initramfs -u" update-initramfs -u

  if [[ -f /var/lib/dkms/mok.pub ]]; then
    run_step_allow_fail "mokutil --import /var/lib/dkms/mok.pub (prompts password)" mokutil --import /var/lib/dkms/mok.pub
  else
    warn "Expected /var/lib/dkms/mok.pub not found. Find it with:"
    warn "  sudo find /var/lib/dkms -maxdepth 3 -name mok.pub -o -name MOK.der -o -name '*.der'"
    warn "Then import the correct file with mokutil --import <path>"
  fi
}

write_post_reboot_checker() {
  cat >/root/dev_ready_post_reboot_check.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo "=== Secure Boot ==="; mokutil --sb-state || true
echo; echo "=== NVIDIA nodes ==="; ls -l /dev/nvidia* || true
echo; echo "=== nvidia-smi ==="; nvidia-smi || true
echo; echo "=== DKMS status ==="; dkms status | grep -i nvidia || true
echo; echo "=== Loaded modules ==="; lsmod | grep -i nvidia || true
echo; echo "=== dmesg (nvidia/mok/secure boot) ==="; dmesg | egrep -i 'nvidia|secure boot|mok' | tail -n 200 || true
EOF
  chmod +x /root/dev_ready_post_reboot_check.sh
  ok "Wrote: /root/dev_ready_post_reboot_check.sh"
}


enable_nvidia_drm_modeset() {
  say "Optional: enable NVIDIA DRM KMS (nvidia-drm.modeset=1) for more reliable X11/SDDM + VT switching"

  # 1) modprobe option (persists across kernel updates)
  run_step_allow_fail "Write /etc/modprobe.d/nvidia-drm.conf" bash -lc 'cat >/etc/modprobe.d/nvidia-drm.conf <<EOF
options nvidia-drm modeset=1
EOF'

  # 2) initramfs so early boot picks it up
  if command -v update-initramfs >/dev/null 2>&1; then
    run_step_allow_fail "update-initramfs -u" update-initramfs -u
  else
    warn "update-initramfs not found; skipping initramfs refresh"
  fi

  # 3) GRUB cmdline (belt-and-suspenders; harmless if already set)
  if [[ -f /etc/default/grub ]]; then
    if grep -qE '(^|[[:space:]])nvidia-drm\.modeset=1([[:space:]]|")' /etc/default/grub; then
      ok "GRUB already contains nvidia-drm.modeset=1"
    else
      run_step_allow_fail "Add nvidia-drm.modeset=1 to GRUB_CMDLINE_LINUX_DEFAULT" bash -lc '
        set -euo pipefail
        if grep -q "^GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub; then
          perl -0777 -i -pe "s/^(GRUB_CMDLINE_LINUX_DEFAULT=\"?)([^\n\"]*)(\"?)/$1nvidia-drm.modeset=1 $2$3/m" /etc/default/grub
        else
          echo "GRUB_CMDLINE_LINUX_DEFAULT=\"nvidia-drm.modeset=1\"" >> /etc/default/grub
        fi
      '
      if command -v update-grub >/dev/null 2>&1; then
        run_step_allow_fail "update-grub" update-grub
      else
        warn "update-grub not found; if you use GRUB, run update-grub manually"
      fi
    fi
  else
    warn "/etc/default/grub not found; skipping GRUB cmdline update"
  fi

  ok "NVIDIA DRM KMS option written. Reboot required for full effect."
}

nvidia_queue_postreboot_checks() {
  # Requires lib/90_postreboot.sh to be sourced (postreboot_add_step).
  if ! command -v postreboot_add_step >/dev/null 2>&1; then
    warn "postreboot_add_step not found; did you source lib/90_postreboot.sh?"
    return 1
  fi

  say "Queueing NVIDIA post-reboot verification steps"
  postreboot_add_step write_post_reboot_checker
  ok "NVIDIA post-reboot checks queued"
}

