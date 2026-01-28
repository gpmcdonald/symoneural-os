#!/bin/bash
# SyMoNeuRaL OS: Final Orchestration Realignment
# Fixes: Authentication loops, pathing errors, and shell compatibility.

export OEROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$OEROOT"

# 1. THE PORTAL (scripts/symon-portal.sh)
# Fixed: Uses /bin/bash for submodule loops, absolute paths for TEMPLATECONF.
cat <<'EOF' > scripts/symon-portal.sh
#!/bin/bash
export OEROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$OEROOT"

echo "➜ Synchronizing Repository Submodules..."
git submodule sync --quiet

# Audit Check
python3 "$OEROOT/scripts/symon-audit.py"
if [ $? -ne 0 ]; then
    echo -e "\n⚠️  ALIGNMENT ERROR"
    printf "Force-align layers locally? [y/N]: "
    read -r fix_choice
    if [[ "$fix_choice" =~ ^[Yy]$ ]]; then
        T_BR=$(python3 -c "import json; print(json.load(open('$OEROOT/manifest.json'))['target_branch'])")
        # Fix: Explicitly use bash to avoid [[ ]] errors in sh
        git submodule foreach "/bin/bash -c '
            EXPECTED=\"$T_BR\"
            [[ \"\$sm_path\" == \"sources/bitbake\" ]] && EXPECTED=\"2.8\"
            echo \"Checking out \$EXPECTED in \$sm_path...\"
            git checkout \$EXPECTED 2>/dev/null || echo \"! Branch not found in \$sm_path\"
        '"
        python3 "$OEROOT/scripts/symon-audit.py" || exit 1
    else
        exit 1
    fi
fi

echo -e "\nSelect Build Flavor:"
echo " 1) SyMoNeuRaL"
echo " 2) Poky"
echo " 3) OE-Core"
printf "Choice [1]: "
read -r c

case ${c:-1} in
    1) export TEMPLATECONF="$OEROOT/meta-symon/conf/templates/default" ; BDIR="build-symon" ;;
    2) export TEMPLATECONF="$OEROOT/sources/poky/meta-poky/conf/templates/default" ; BDIR="build-poky" ;;
    3) export TEMPLATECONF="$OEROOT/sources/openembedded-core/meta/conf/templates/default" ; BDIR="build-oecore" ;;
esac

# Path Validation
if [ ! -d "$TEMPLATECONF" ]; then
    echo "❌ Error: Directory not found: $TEMPLATECONF"
    exit 1
fi

export BITBAKEDIR="$OEROOT/sources/bitbake"
. ./oe-init-build-env "$BDIR"
EOF
chmod +x scripts/symon-portal.sh

echo "✓ Logic Realignment Complete."
echo "➜ Run: . scripts/symon-portal.sh"
