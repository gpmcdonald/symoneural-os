#!/bin/bash
# synapse: SyMoNeuRaL Build Portal

# 1. ROBUST ROOT DETECTION
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
ROOT_DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# 2. AUTO-REPAIR SUBMODULES
if [ ! -f "$ROOT_DIR/openembedded-core/meta/conf/layer.conf" ]; then
    echo "➜ synapse: Engine missing. Initializing submodules..."
    cd "$ROOT_DIR" || exit 1
    git submodule update --init --recursive
fi

# 3. MENU
echo "===================================================="
echo "    S Y N A P S E  -  SyMoNeuRaL OS Portal"
echo "===================================================="
echo " 1) symoneural-image-base   (Custom / Headless)"
echo " 2) symoneural-image-gui    (Custom / RTX 5070 Ti)"
echo " 3) core-image-minimal      (Upstream Reference)"
echo " 4) Factory Reset           (Clean All Build Dirs)"
echo "----------------------------------------------------"
read -p "Selection: " choice

# 4. LOGIC
case $choice in
    1|2)
        TARGET_DIR="symoneural-build"
        # TARGET A: Point to scripts-symoneural
        LINK_TARGET="scripts-symoneural/setup-environment"
        [ "$choice" == "1" ] && TARGET="symoneural-image-base" || TARGET="symoneural-image-gui"
        ;;
    3)
        TARGET_DIR="oe-core-ref-build"
        # TARGET B: Point to upstream scripts
        LINK_TARGET="openembedded-core/oe-init-build-env"
        TARGET="core-image-minimal"
        ;;
    4)
        cd "$ROOT_DIR" || exit 1
        echo "➜ synapse: Wiping build directories..."
        rm -rf symoneural-build oe-core-ref-build .templateconf symoneural-init-build-env
        echo "✓ Reset complete. Scrubbing memory..."
        unset BBPATH BUILDDIR TEMPLATECONF OEROOT
        export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
        echo "➜ Spawning clean shell..."
        exec bash
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

# 5. INITIALIZATION
cd "$ROOT_DIR" || exit 1

echo "➜ Configuring Smart Link..."
rm -f symoneural-init-build-env
ln -s "$LINK_TARGET" symoneural-init-build-env

echo "   Linked: symoneural-init-build-env -> $LINK_TARGET"
echo "   Target: $TARGET_DIR"

source ./symoneural-init-build-env "$TARGET_DIR"

echo "----------------------------------------------------"
echo "✓ Environment Ready: $TARGET"
echo "➜ Run: bitbake $TARGET"
echo "----------------------------------------------------"

# 6. SHELL HANDOFF
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    export PS1="\[\e[1;32m\]synapse\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "
    bash --rcfile <(echo "source /etc/bash.bashrc; source ~/.bashrc; export PS1='\[\e[1;32m\]synapse\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '") -i
fi
