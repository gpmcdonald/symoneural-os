#!/bin/bash
export OEROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$OEROOT"

echo "➜ Synchronizing Repository Submodules..."
git submodule sync --quiet
git submodule update --init --recursive --progress

python3 "$OEROOT/scripts/symon-audit.py"
if [ $? -ne 0 ]; then
    echo -e "\n⚠️  ALIGNMENT ERROR: Submodule drift detected."
    read -p "Force-align layers to manifest targets? [y/N]: " fix_choice
    if [[ "$fix_choice" =~ ^[Yy]$ ]]; then
        T_BR=$(python3 -c "import json; print(json.load(open('$OEROOT/manifest.json'))['target_branch'])")
        git submodule foreach "
            if [[ \"\$sm_path\" == \"sources/bitbake\" ]]; then
                git fetch origin 2.8 && git checkout 2.8 && git pull origin 2.8
            else
                git fetch origin $T_BR && git checkout $T_BR && git pull origin $T_BR
            fi"
        python3 "$OEROOT/scripts/symon-audit.py" || { echo "❌ Alignment failed."; return 1; }
    else
        echo "❌ Aborting build environment setup."
        return 1 2>/dev/null || exit 1
    fi
fi

echo -e "\nSelect Build Flavor:"
echo " 1) SyMoNeuRaL (symonos)"
echo " 2) Poky       (poky)"
echo " 3) OE-Core    (nodistro)"
read -p "Selection [1]: " choice

case ${choice:-1} in
    1) export TEMPLATECONF="$OEROOT/meta-symon/conf/templates/default" ; BDIR="build-symon" ;;
    2) export TEMPLATECONF="$OEROOT/sources/poky/meta-poky/conf/templates/default" ; BDIR="build-poky" ;;
    3) export TEMPLATECONF="$OEROOT/sources/openembedded-core/meta/conf/templates/default" ; BDIR="build-oecore" ;;
esac

export BITBAKEDIR="$OEROOT/sources/bitbake"
. ./oe-init-build-env "$BDIR"
