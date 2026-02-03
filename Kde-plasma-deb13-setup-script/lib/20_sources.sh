#!/usr/bin/env bash
set -euo pipefail

enable_contrib_nonfree() {
  say "Enable contrib/non-free/non-free-firmware (robust, best effort)"
  pm_install_smart perl

  local files=()
  [[ -f /etc/apt/sources.list ]] && files+=("/etc/apt/sources.list")
  if compgen -G "/etc/apt/sources.list.d/*.list" >/dev/null 2>&1; then
    while IFS= read -r f; do files+=("$f"); done < <(ls -1 /etc/apt/sources.list.d/*.list 2>/dev/null || true)
  fi

  if (( ${#files[@]} == 0 )); then
    warn "No sources list files found to edit."
    return 0
  fi

  for f in "${files[@]}"; do
    run_step_allow_fail "Patch APT components in: $f" bash -lc "
      perl -0777 -pe '
        my @need = qw(contrib non-free non-free-firmware);
        my @lines = split(/\\n/, \$_, -1);
        for my \$i (0..$#lines) {
          my \$l = \$lines[\$i];
          next if \$l =~ /^\\s*#/;
          next unless \$l =~ /^\\s*deb(?:-src)?\\s+/;
          next unless \$l =~ /\\bmain\\b/;

          my \$changed = 0;
          for my \$c (@need) {
            if (\$l !~ /\\b\\Q\$c\\E\\b/) { \$l .= \" \$c\"; \$changed = 1; }
          }

          if (\$changed) {
            my @t = split(/\\s+/, \$l);
            my %seen;
            my @out;
            for my \$tok (@t) {
              next if \$tok eq \"\";
              if (\$tok =~ /^(contrib|non-free|non-free-firmware)\$/) {
                next if \$seen{\$tok}++;
              }
              push @out, \$tok;
            }
            \$l = join(\" \", @out);
          }

          \$lines[\$i] = \$l;
        }
        \$_ = join(\"\\n\", @lines);
      ' -i '$f' || true
    "
  done

  run_step_allow_fail "apt-get update (after sources)" apt-get update
}

optional_repairs_upgrades() {
  if ask_yn "Run dpkg --configure -a (repair)?" "yes"; then run_step_allow_fail "dpkg --configure -a" dpkg --configure -a; fi
  if ask_yn "Run apt-get -f install (repair deps)?" "yes"; then run_step_allow_fail "apt-get -f install" apt-get -y -f install; fi
  if ask_yn "Run apt-get update + full-upgrade now?" "yes"; then
    run_step_allow_fail "apt-get update" apt-get update
    run_step_allow_fail "apt-get full-upgrade" apt-get -y full-upgrade
  fi
}