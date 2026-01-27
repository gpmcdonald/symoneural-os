#!/bin/bash
# synapse: The SyMoNeuRaL Build Portal

# 1. FIND THE REPO ROOT
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
ROOT_DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"
BIN_PATH="$HOME/.local/bin/synapse"

# --- 2. Installer / Uninstaller ---
if [[ "$1" == "--install" ]]; then
    echo "➜ synapse: Installing to $HOME/.local/bin..."
    mkdir -p "$HOME/.local/bin"
    cp "$0" "$BIN_PATH"
    chmod +x "$BIN_PATH"
    echo "✓ Done. Run 'synapse' from anywhere."
    exit 0
elif [[ "$1" == "--remove" ]]; then
    if [ -f "$BIN_PATH" ]; then
        rm "$BIN_PATH"
        echo "✓ synapse: Binary removed from $HOME/.local/bin."
    else
        echo "ℹ synapse: No installation found in $HOME/.local/bin."
    fi
    exit 0
fi

cd "$ROOT_DIR" || { echo "❌ Error: Could not find repository root."; exit 1; }

# --- 3. Submodule & Dependency Check ---
if [ ! -f "meta-poky/conf/layer.conf" ]; then
    echo "➜ synapse: Synchronizing project submodules..."
    git submodule update --init --recursive
fi

# --- 4. The Clean-Up ---
if command -v bitbake >/dev/null 2>&1; then bitbake -m >/dev/null 2>&1; fi
unset BBPATH BUILDDIR TEMPLATECONF

echo "===================================================="
echo "    S Y N A P S E  -  SyMoNeuRaL OS Portal"
echo "===================================================="
echo " 1) Headless Base     (Server/Embedded)"
echo " 2) Neural-GUI        (NVIDIA RTX 5070 Ti Optimised)"
echo " 3) OE-Core Reference (Upstream Testing)"
echo " 4) Factory Reset     (Wipe build dirs)"
echo "----------------------------------------------------"
read -p "Selection: " choice

case $choice in
    1|2)
        TARGET_DIR="symoneural-build"
        T_PATH="meta-symoneural/conf/templates/symoneural-templates"
        [ "$choice" == "1" ] && TARGET="symoneural-image-base" || TARGET="symoneural-image-gui"
        ;;
    3)
        TARGET_DIR="oe-core-ref-build"
        T_PATH="openembedded-core/meta/conf/templates/default"
        TARGET="core-image-minimal"
        ;;
    4)
        sudo rm -rf symoneural-build oe-core-ref-build
        echo "✓ synapse: Build environments purged." ; exit 0
        ;;
    *) exit 1 ;;
esac

# --- 5. Directory Audit ---
if [ -d "$TARGET_DIR" ]; then
    echo "📂 Found existing $TARGET_DIR."
    read -p "   [C]ontinue or [R]eset? " br
    [[ "$br" =~ ^[Rr]$ ]] && sudo rm -rf "$TARGET_DIR"
fi

# --- 6. Initialization ---
echo "TEMPLATECONF=\"$T_PATH\"" > "$ROOT_DIR/.templateconf"
export TEMPLATECONF="$ROOT_DIR/$T_PATH"
. ./oe-init-build-env "$TARGET_DIR"

# Ensure templates are available in the local build
cp -f "$ROOT_DIR/$T_PATH/local.conf.sample" "conf/" 2>/dev/null

echo "----------------------------------------------------"
echo "✓ Connection Established: $TARGET"
echo "➜ Use 'bitbake $TARGET' to begin."
echo "----------------------------------------------------"

# --- 7. Launch the Portal ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    export PS1="\[\e[1;32m\]synapse\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "
    exec bash --rcfile <(echo "source /etc/bash.bashrc; source ~/.bashrc; export PS1='\[\e[1;32m\]synapse\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '") -i
fi
