#!/usr/bin/env bash
set -euo pipefail

collect_machine_info() {
  say "Collecting system info (fastfetch preferred)"
  pm_install_smart fastfetch
  if command -v fastfetch >/dev/null 2>&1; then
    run_step_allow_fail "fastfetch" fastfetch
  else
    run_step_allow_fail "hostnamectl" hostnamectl
    run_step_allow_fail "uname -a" uname -a
    run_step_allow_fail "os-release" bash -lc "cat /etc/os-release || true"
    run_step_allow_fail "lspci GPUs" bash -lc "lspci -nn | egrep -i 'vga|3d|nvidia|amd' || true"
  fi
}

choose_target_user() {
  local def="${SUDO_USER:-}"
  [[ -z "$def" || "$def" == "root" ]] && def="$(logname 2>/dev/null || true)"
  TARGET_USER="$(ask_val "Which user should receive group memberships?" "${def:-}")"
  [[ -n "$TARGET_USER" ]] && ok "TARGET_USER=$TARGET_USER" || warn "No TARGET_USER provided."
}

apply_user_groups() {
  [[ -z "${TARGET_USER:-}" ]] && return 0
  if ! id "$TARGET_USER" >/dev/null 2>&1; then warn "User '$TARGET_USER' not found; skipping groups."; return 0; fi

  if ask_yn "Add ${TARGET_USER} to sudo group?" "yes"; then
    run_step_allow_fail "usermod -aG sudo ${TARGET_USER}" usermod -aG sudo "$TARGET_USER"
  fi

  if ask_yn "Add ${TARGET_USER} to video group?" "yes"; then
    run_step_allow_fail "usermod -aG video ${TARGET_USER}" usermod -aG video "$TARGET_USER"
  fi

  if ask_yn "Add ${TARGET_USER} to render group?" "yes"; then
    getent group render >/dev/null 2>&1 || run_step_allow_fail "Create render group" groupadd render
    run_step_allow_fail "usermod -aG render ${TARGET_USER}" usermod -aG render "$TARGET_USER"
  fi

  if ask_yn "Add ${TARGET_USER} to www-data group (useful for local web dev)?" "no"; then
    run_step_allow_fail "usermod -aG www-data ${TARGET_USER}" usermod -aG www-data "$TARGET_USER"
  fi
}

enable_i386() {
  run_step_allow_fail "dpkg --add-architecture i386" dpkg --add-architecture i386
  run_step_allow_fail "apt-get update (after i386)" apt-get update
}

install_base_tooling() {
  pm_install_smart \
    ca-certificates curl wget gnupg apt-transport-https software-properties-common \
    git rsync unzip zip p7zip-full jq tmux htop nano vim \
    pciutils usbutils lsb-release net-tools dnsutils iproute2 traceroute tree file \
    build-essential pkg-config cmake ninja-build clang llvm dkms \
    "linux-headers-$(uname -r)"
}