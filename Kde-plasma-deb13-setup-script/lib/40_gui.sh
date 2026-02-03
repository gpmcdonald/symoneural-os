#!/usr/bin/env bash
set -euo pipefail

install_x11_stack() {
  pm_install_smart \
    xorg xserver-xorg-core xserver-xorg-video-all xserver-xorg-input-all \
    xinit x11-xserver-utils mesa-utils \
    libglvnd-dev libegl1-mesa-dev \
    libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev
}

install_kde_sddm() {
  local choices=()
  for c in kde-plasma-desktop kde-standard plasma-desktop; do
    pkg_exists "$c" && choices+=("$c")
  done

  if (( ${#choices[@]} == 0 )); then
    warn "No known KDE/Plasma meta package found in APT cache."
    warn "You can still install X11 only, or search manually: apt-cache search plasma"
    return 0
  fi

  echo
  say "KDE/Plasma meta packages found:"
  local i=1
  for c in "${choices[@]}"; do echo "  $i) $c"; i=$((i+1)); done
  echo "  0) Skip KDE/Plasma install"

  local sel
  while true; do
    sel="$(ask_val "Choose KDE/Plasma meta to install" "1")"
    [[ "$sel" =~ ^[0-9]+$ ]] || { echo "Invalid."; continue; }
    (( sel == 0 )) && { warn "Skipping KDE/Plasma."; return 0; }
    if (( sel >= 1 && sel <= ${#choices[@]} )); then
      local pick="${choices[$((sel-1))]}"
      pm_install_smart "$pick" sddm
      pkg_exists plasma-workspace-x11 && pm_install_smart plasma-workspace-x11 || true
      run_step_allow_fail "Enable SDDM" systemctl enable sddm
      run_step_allow_fail "Set graphical target" systemctl set-default graphical.target
      return 0
    fi
    echo "Invalid."
  done
}