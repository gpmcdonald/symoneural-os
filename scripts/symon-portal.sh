#!/bin/bash
# symon-portal: SyMoNeuRaL Environment Orchestrator

# 1. ROOT DETECTION
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
export OEROOT="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# 2. RUN AUDIT
python3 "$OEROOT/scripts/symon-audit.py"

# 3. SELECTION
echo "----------------------------------------------------"
echo " 1) symoneural-image-base (Standard Console)"
echo " 2) symoneural-image-tiny (Minimal Footprint)"
echo " 3) symoneural-xfce-image (Workstation GUI)"
read -p "Selection: " choice

case $choice in
    1) export BDIR="build-base";;
    2) export BDIR="build-tiny";;
    3) export BDIR="build-gui";;
    *) echo "Aborting."; exit 1;;
esac

# 4. ENVIRONMENT EXPORTS
export TEMPLATECONF="$OEROOT/meta-symon/conf/templates/default"
export BITBAKEDIR="$OEROOT/sources/bitbake"

# 5. INITIALIZE
cd "$OEROOT"
. ./oe-init-build-env "$BDIR"
