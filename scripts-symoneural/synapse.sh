#!/bin/bash
# synapse: SyMoNeuRaL Build Portal

# 1. ROOT DETECTION
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
ROOT_DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# 2. ENGINE CHECK
if [ ! -d "$ROOT_DIR/meta-symoneural/meta" ]; then
    echo "❌ CRITICAL: 'meta-symoneural/meta' is missing!"
    exit 1
fi

# 3. FIND INIT SCRIPT
if [ -f "$ROOT_DIR/openembedded-core/oe-init-build-env" ]; then
    STANDARD_INIT="openembedded-core/oe-init-build-env"
elif [ -f "$ROOT_DIR/scripts/oe-buildenv-internal" ]; then
    STANDARD_INIT="scripts/oe-buildenv-internal"
else
    echo "❌ Error: Could not find Yocto init script."
    exit 1
fi

# 4. MENU
echo "===================================================="
echo "    S Y N A P S E  -  SyMoNeuRaL OS Portal"
echo "===================================================="
echo " 1) symoneural-image-base   (Custom / Minimal)"
echo " 2) symoneural-image-gui    (Custom / Minimal)"
echo " 3) core-image-minimal      (Upstream Reference)"
echo " 4) Factory Reset           (Clean All Build Dirs)"
echo "----------------------------------------------------"
read -p "Selection: " choice

# 5. LOGIC
case $choice in
    1|2)
        TARGET_DIR="symoneural-build"
        T_PATH="meta-symoneural/conf/templates/default"
        [ "$choice" == "1" ] && TARGET="symoneural-image-base" || TARGET="symoneural-image-gui"
        ;;
    3)
        TARGET_DIR="oe-core-ref-build"
        T_PATH="meta/conf/templates/default"
        TARGET="core-image-minimal"
        ;;
    4)
        echo "➜ synapse: Wiping build directories..."
        cd "$ROOT_DIR"
        if [ -d "symoneural-build" ]; then sudo rm -rf symoneural-build; fi
        if [ -d "oe-core-ref-build" ]; then sudo rm -rf oe-core-ref-build; fi
        rm -f .templateconf synapse-init-build-env
        echo "✓ Reset complete."
        exec bash
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

# 6. EXECUTION
cd "$ROOT_DIR" || exit 1

# A. Create the interface link
rm -f synapse-init-build-env
ln -s "$STANDARD_INIT" synapse-init-build-env

# B. Set the template variable (FIX FOR "not found" ERROR)
export TEMPLATECONF="$ROOT_DIR/$T_PATH"
# We write the variable assignment so the script doesn't try to execute a directory path
echo "TEMPLATECONF=\"$T_PATH\"" > .templateconf

# C. Run the build init (SILENCED)
# This hides "You had no conf...", "Yocto docs...", etc.
source ./synapse-init-build-env "$TARGET_DIR" > /dev/null

# D. Explicitly Show YOUR Custom Notes
echo "----------------------------------------------------"
echo "✓ Environment Ready: $TARGET"
echo "----------------------------------------------------"
if [ -f "$ROOT_DIR/$T_PATH/conf-notes.txt" ]; then
    cat "$ROOT_DIR/$T_PATH/conf-notes.txt"
fi
echo ""

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    export PS1="\[\e[1;32m\]synapse\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "
    bash --rcfile <(echo "source /etc/bash.bashrc; source ~/.bashrc; export PS1='\[\e[1;32m\]synapse\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '") -i
fi
