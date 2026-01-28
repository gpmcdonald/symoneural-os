#!/bin/bash
# synapse: SyMoNeuRaL Orchestrator

# 1. ROOT DETECTION
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
export OEROOT="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# 2. RUN GOVERNANCE
python3 "$OEROOT/scripts/synapse_audit.py" || exit 1

# 3. SELECTION
echo "----------------------------------------------------"
echo " 1) symoneural-image-base"
echo " 2) symoneural-image-gui"
echo " 3) core-image-minimal"
read -p "Selection: " choice

case $choice in
    1|2)
        export BDIR="symoneural-build"
        export TEMPLATECONF="$OEROOT/meta-symoneural/conf/templates/default"
        ;;
    3)
        export BDIR="oe-core-ref-build"
        export TEMPLATECONF="$OEROOT/sources/openembedded-core/meta/conf/templates/default"
        ;;
    *) exit 1 ;;
esac

# 4. INITIALIZE
cd "$OEROOT"
# Industry Standard: Tell the OE scripts exactly where BitBake lives
# in our custom 'sources' layout so discovery doesn't fail.
export BITBAKEDIR="$OEROOT/sources/bitbake"

# Now source the official entry point
. ./oe-init-build-env "$BDIR"
