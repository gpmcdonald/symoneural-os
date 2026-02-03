#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

# Load shared helpers (required by NVIDIA + postreboot logic)
# shellcheck source=/dev/null
. "$LIB_DIR/00_core.sh"
# shellcheck source=/dev/null
. "$LIB_DIR/10_pkg.sh"

# Feature modules
# shellcheck source=/dev/null
. "$LIB_DIR/80_nvidia.sh"
# shellcheck source=/dev/null
. "$LIB_DIR/90_postreboot.sh"

prompt_yes_no() {
  local prompt="$1"
  local default="$2"
  local reply

  if [[ "$default" == "y" ]]; then
    prompt="$prompt [Y/n]: "
  else
    prompt="$prompt [y/N]: "
  fi

  read -r -p "$prompt" reply || true

  case "$reply" in
    [Yy]*) return 0 ;;
    [Nn]*) return 1 ;;
    "") [[ "$default" == "y" ]] && return 0 || return 1 ;;
    *) echo "Please answer y or n." ; prompt_yes_no "$1" "$default" ;;
  esac
}

main() {
  say "=== KDE Debian 13 + NVIDIA setup (Phase 1) ==="

  # Initialize post-reboot continuation
  postreboot_init "$SCRIPT_DIR"

  # --- NVIDIA / Secure Boot / Driver prep (pre-reboot) ---

  if prompt_yes_no "Purge existing NVIDIA/CUDA stack first?" "n"; then
    purge_nvidia_stack
  fi

  if prompt_yes_no "Install Secure Boot / MOK tooling?" "y"; then
    install_mok_tools
  fi

  if prompt_yes_no "Enable NVIDIA repository (Debian 13)?" "y"; then
    enable_nvidia_repo_debian13
  fi

  if prompt_yes_no "Install NVIDIA OPEN driver stack now?" "y"; then
    install_nvidia_open_stack
  fi

  if prompt_yes_no "Enable NVIDIA DRM KMS (nvidia-drm.modeset=1)?" "y"; then
    enable_nvidia_drm_modeset
  fi

  # --- Queue post-reboot verification / continuation ---

  postreboot_add_step write_post_reboot_checker

  # Install + enable one-shot service for next boot
  postreboot_install_service
  postreboot_enable_next_boot

  say "Phase 1 complete. The computer is about to reboot to continue setup automatically on next boot."
  say "Rebooting in 10 seconds... (press Ctrl+C to cancel)"
  for i in {10..1}; do
    echo "  reboot in ${i}s..."
    sleep 1
  done
  reboot
}

main "$@"
