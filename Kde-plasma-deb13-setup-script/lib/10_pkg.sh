#!/usr/bin/env bash
set -euo pipefail

PM="apt-get"
APT_SIM_OUT=""

declare -A PKG_FALLBACKS=(
  [fastfetch]="fastfetch neofetch"
  [fd-find]="fd-find"
  [ripgrep]="ripgrep"
  [php-fpm]="php-fpm php8.3-fpm php8.2-fpm php8.4-fpm"
  [fonts-terminus]="fonts-terminus"
  [nvidia-open]="nvidia-open"
  [nvidia-kernel-open-dkms]="nvidia-kernel-open-dkms"
  [nvidia-driver-assistant]="nvidia-driver-assistant"
  [kde-plasma-desktop]="kde-plasma-desktop kde-standard plasma-desktop"
  [plasma-workspace-x11]="plasma-workspace-x11"
  [sddm]="sddm"
  [xorgxrdp]="xorgxrdp"
  [libncurses5-dev]="libncurses-dev libncurses6 libncursesw6 libncursesw6-dev"
  [libtinfo5]="libtinfo6 libtinfo5"
  [libsdl1.2-dev]="libsdl1.2-dev libsdl2-dev"
)

cleanup_pkg() {
  [[ -n "${APT_SIM_OUT:-}" && -f "${APT_SIM_OUT:-}" ]] && rm -f "$APT_SIM_OUT" || true
}
trap cleanup_pkg EXIT

pkg_exists() { apt-cache show "$1" >/dev/null 2>&1; }

list_candidates_from_cache() {
  local term="$1"
  apt-cache search --names-only "$term" 2>/dev/null | awk '{print $1}' | head -n 30
}

offer_replacement() {
  local missing="$1"
  local choices=()

  if [[ -n "${PKG_FALLBACKS[$missing]:-}" ]]; then
    # shellcheck disable=SC2206
    local arr=( ${PKG_FALLBACKS[$missing]} )
    for c in "${arr[@]}"; do pkg_exists "$c" && choices+=("$c"); done
  fi

  if (( ${#choices[@]} == 0 )); then
    while IFS= read -r c; do [[ -n "$c" ]] && choices+=("$c"); done < <(list_candidates_from_cache "$missing")
  fi

  if (( ${#choices[@]} > 1 )); then
    mapfile -t choices < <(printf "%s\n" "${choices[@]}" | awk '!seen[$0]++')
  fi

  if (( ${#choices[@]} == 0 )); then
    warn "No replacement candidates found for: $missing"
    return 1
  fi

  echo
  echo "Package not found: $missing"
  echo "Choose a replacement:"
  local i=1
  for c in "${choices[@]}"; do echo "  $i) $c"; i=$((i+1)); done
  echo "  0) Skip"

  local sel
  while true; do
    sel="$(ask_val "Select" "1")"
    [[ "$sel" =~ ^[0-9]+$ ]] || { echo "Invalid."; continue; }
    (( sel == 0 )) && return 2
    if (( sel >= 1 && sel <= ${#choices[@]} )); then
      echo "${choices[$((sel-1))]}"
      return 0
    fi
    echo "Invalid."
  done
}

simulate_install() {
  rm -f "${APT_SIM_OUT:-}" 2>/dev/null || true
  APT_SIM_OUT="$(mktemp /tmp/apt_sim.XXXXXX)"
  apt-get -s install "$@" >"$APT_SIM_OUT" 2>&1 || true
  if grep -qiE "Unable to correct problems|not installable|not going to be installed|held broken packages" "$APT_SIM_OUT"; then
    return 1
  fi
  return 0
}

extract_missing_deps() {
  [[ -n "${APT_SIM_OUT:-}" && -f "$APT_SIM_OUT" ]] || return 0
  awk '
    BEGIN{IGNORECASE=1}
    /Depends:/{ 
      line=$0
      sub(/^.*Depends:\s*/, "", line)
      sub(/\s+but.*$/, "", line)
      split(line, alts, "|")
      dep=alts[1]
      gsub(/[(].*$/, "", dep)
      gsub(/^\s+|\s+$/, "", dep)
      if (dep != "") print dep
    }
  ' "$APT_SIM_OUT" | awk '!seen[$0]++'
}

safe_apt_recover() {
  run_step_allow_fail "Repair: dpkg --configure -a" dpkg --configure -a
  run_step_allow_fail "Repair: apt-get -f install" apt-get -y -f install
  run_step_allow_fail "Repair: apt-get update" apt-get update
}

pm_install_smart() {
  local requested=("$@")
  local resolved=()

  for p in "${requested[@]}"; do
    if pkg_exists "$p"; then
      resolved+=("$p"); continue
    fi
    local repl=""
    if repl="$(offer_replacement "$p")"; then
      [[ -n "$repl" ]] && resolved+=("$repl")
    else
      local rc=$?
      if [[ $rc -eq 2 ]]; then warn "Skipping missing package: $p"; else warn "No replacement; skipping: $p"; fi
    fi
  done

  (( ${#resolved[@]} == 0 )) && { warn "Nothing to install after resolution."; return 0; }

  if ! simulate_install "${resolved[@]}"; then
    warn "Dependency issues detected for: ${resolved[*]}"
    echo; echo "APT simulation tail:"; tail -n 80 "$APT_SIM_OUT" || true; echo

    if ask_yn "Attempt automatic repair (dpkg --configure -a + apt-get -f install)?" "yes"; then
      safe_apt_recover
    fi

    mapfile -t deps < <(extract_missing_deps)
    if (( ${#deps[@]} > 0 )) && ask_yn "Try installing AVAILABLE missing deps first, then retry?" "yes"; then
      local dep_install=()
      for d in "${deps[@]}"; do pkg_exists "$d" && dep_install+=("$d"); done
      (( ${#dep_install[@]} > 0 )) && run_step_allow_fail "Install missing deps (available)" $PM install -y "${dep_install[@]}"
    fi
  fi

  run_step_allow_fail "Install packages: ${resolved[*]}" $PM install -y "${resolved[@]}"
}

maybe_use_nala() {
  run_step_allow_fail "apt-get update (initial)" apt-get update
  if command -v nala >/dev/null 2>&1; then
    if ask_yn "Use nala as package manager?" "yes"; then PM="nala"; ok "Using nala."; else PM="apt-get"; fi
  else
    if ask_yn "Install nala and use it?" "yes"; then
      run_step_allow_fail "Install nala" apt-get install -y nala
      command -v nala >/dev/null 2>&1 && PM="nala" || PM="apt-get"
    fi
  fi
  ok "Selected package manager: $PM"
}