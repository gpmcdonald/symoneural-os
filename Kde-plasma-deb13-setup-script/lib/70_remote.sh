#!/usr/bin/env bash
set -euo pipefail

configure_ssh() {
  local port="$1"
  pm_install_smart openssh-server
  local cfg="/etc/ssh/sshd_config"
  if grep -qE '^\s*#?\s*Port\s+' "$cfg"; then
    run_step_allow_fail "Set SSH Port ${port}" sed -i "s/^\s*#\?\s*Port\s\+.*/Port ${port}/" "$cfg"
  else
    run_step_allow_fail "Append SSH Port ${port}" bash -lc "echo 'Port ${port}' >> '$cfg'"
  fi
  run_step_allow_fail "Enable ssh" systemctl enable ssh
  run_step_allow_fail "Restart ssh" systemctl restart ssh
}

configure_xrdp() {
  local port="$1"
  pm_install_smart xrdp xorgxrdp
  local ini="/etc/xrdp/xrdp.ini"
  run_step_allow_fail "Set XRDP port=${port}" bash -lc "sed -i -E 's/^[[:space:]]*port=.*/port=${port}/' '$ini' || true"
  run_step_allow_fail "Enable xrdp" systemctl enable xrdp
  run_step_allow_fail "Restart xrdp" systemctl restart xrdp
}
