#!/usr/bin/env bash
set -euo pipefail

install_terminus_fonts() {
  pm_install_smart fonts-terminus console-setup
  run_step_allow_fail "Update console-setup (CODESET)" sed -i 's/^CODESET=.*/CODESET="guess"/' /etc/default/console-setup
  run_step_allow_fail "Update console-setup (FONTFACE)" sed -i 's/^FONTFACE=.*/FONTFACE="TerminusBold"/' /etc/default/console-setup
  run_step_allow_fail "Update console-setup (FONTSIZE)" sed -i 's/^FONTSIZE=.*/FONTSIZE="10x18"/' /etc/default/console-setup
  run_step_allow_fail "update-initramfs -u (console font)" update-initramfs -u
}
