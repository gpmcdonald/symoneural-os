#!/usr/bin/env bash
set -euo pipefail

TS="$(date +%Y%m%d-%H%M%S)"
LOG="/var/log/symon_deb13_devready_${TS}.log"
FAILURES=()

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; BLUE=$'\033[0;34m'; RC=$'\033[0m'

say()  { echo "${BLUE}[*]${RC} $*"; }
ok()   { echo "${GREEN}[OK]${RC} $*"; }
warn() { echo "${YELLOW}[WARN]${RC} $*"; }
bad()  { echo "${RED}[FAIL]${RC} $*"; }
log_line() { echo "[$(date -Is)] $*" >>"$LOG"; }

run_step() {
  local name="$1"; shift
  echo; say "$name"
  log_line "STEP: $name"
  log_line "CMD: $*"
  if "$@"; then
    ok "$name"
    log_line "RESULT: OK"
    return 0
  else
    bad "$name (see log: $LOG)"
    log_line "RESULT: FAIL"
    FAILURES+=("$name")
    return 1
  fi
}
run_step_allow_fail() { run_step "$@" || true; }

ask_yn() {
  local prompt="$1"; local def="${2:-yes}"
  local dshow="[y/N]"; [[ "$def" == "yes" ]] && dshow="[Y/n]"
  while true; do
    read -r -p "${prompt} ${dshow}: " ans || true
    ans="${ans:-}"
    if [[ -z "$ans" ]]; then [[ "$def" == "yes" ]] && return 0 || return 1; fi
    case "$ans" in y|Y|yes|YES) return 0 ;; n|N|no|NO) return 1 ;; *) echo "Please answer y or n." ;; esac
  done
}

ask_val() {
  local prompt="$1"; local def="${2:-}"; local ans
  if [[ -n "$def" ]]; then
    read -r -p "${prompt} [${def}]: " ans || true
    ans="${ans:-$def}"
  else
    read -r -p "${prompt}: " ans || true
  fi
  echo "$ans"
}

ensure_root() {
  if [[ "${EUID}" -eq 0 ]]; then return 0; fi
  echo; say "This script needs sudo; you'll be prompted for your password."
  sudo -v
  exec sudo -E bash "$0" "$@"
}

init_logging() {
  mkdir -p "$(dirname "$LOG")"
  touch "$LOG"
  exec > >(tee -a "$LOG") 2>&1
}

print_summary() {
  echo; say "SUMMARY"
  echo "  Log: $LOG"
  if (( ${#FAILURES[@]} > 0 )); then
    warn "Failures recorded:"
    for f in "${FAILURES[@]}"; do echo "  - $f"; done
    echo; warn "Open the log to see exact errors:"
    echo "  $LOG"
  else
    ok "No failures recorded."
  fi

  echo
  say "If you installed NVIDIA with Secure Boot ON:"
  echo "  - You may have been prompted for a MOK password."
  echo "  - Reboot -> Enroll MOK -> Continue -> Yes -> enter password -> reboot."
  echo "After login, run:"
  echo "  sudo /root/dev_ready_post_reboot_check.sh"
  echo
}