#!/bin/bash
set -e

echo "=================================================="
echo "   SymoNeuRaL Structure & Documentation Setup"
echo "=================================================="

LAYER_DIR="meta-symoneural"

# 1. Create Directories INSIDE the Layer (Consistency Fix)
# --------------------------------------------------
echo "[1/3] Creating scripts inside $LAYER_DIR..."

# Create custom scripts folder
mkdir -p "$LAYER_DIR/scripts"
cat <<EOF > "$LAYER_DIR/scripts/README.md"
# SymoNeuRaL Scripts
This directory contains build wrappers and CI tools specific to the SymoNeuRaL OS.
EOF

# Create a sample build wrapper
cat <<EOF > "$LAYER_DIR/scripts/build.sh"
#!/bin/bash
# Usage: ./meta-symoneural/scripts/build.sh
# Wrapper to initialize env and build the main image
source oe-init-build-env build
bitbake symoneural
EOF
chmod +x "$LAYER_DIR/scripts/build.sh"

# Create custom contrib folder
mkdir -p "$LAYER_DIR/contrib"
cat <<EOF > "$LAYER_DIR/contrib/README.md"
# SymoNeuRaL Contrib
Place experimental tools and one-off hacks here.
EOF

# 2. Generate the Main Project README
# --------------------------------------------------
echo "[2/3] Generating Project Manual (README.md)..."

cat <<EOF > README.md
# SymoNeuRaL OS

**SymoNeuRaL** is a custom embedded Linux distribution built on the Yocto Project (OpenEmbedded).

## 📂 Repository Structure

This repository uses the "Combo-Layer" pattern. The root directory contains the build engine, while **meta-symoneural** contains your distribution logic.

### 🔴 Your Project (meta-symoneural)
Everything specific to your OS lives here:
* **\`conf/\`**: Distro policies and machine definitions (Alienware/RPi).
* **\`recipes-*/\`**: Software packages and .bb files.
* **\`scripts/\`**: Custom build wrappers and CI tools.
* **\`contrib/\`**: Experimental hacks and tools.

### 🔵 Upstream Engine (Do Not Edit)
These are standard OpenEmbedded components.
* **\`bitbake/\`**: The task scheduler.
* **\`meta/\`**: OpenEmbedded Core (GCC, glibc, core tools).
* **\`meta-openembedded/\`**: Community layers.
* **\`scripts/\`**: Standard Yocto utilities (runqemu, devtool).
* **\`contrib/\`**: Community extras (vim syntax, tab completion).

---

## 🚀 Quick Start

1. **Initialize Environment**
   \`\`\`bash
   source oe-init-build-env build
   \`\`\`

2. **Build the OS**
   \`\`\`bash
   bitbake symoneural
   \`\`\`

3. **Using Custom Scripts**
   Your custom scripts are located in the layer:
   \`\`\`bash
   ./meta-symoneural/scripts/build.sh
   \`\`\`

## Supported Hardware
* **Alienware R11** (NVIDIA RTX 5070 Ti)
* **Raspberry Pi 4** (64-bit)
* **Generic x86-64** (UEFI)

EOF

# 3. Cleanup
# --------------------------------------------------
echo "[3/3] Done."
echo "--------------------------------------------------"
echo "SUCCESS. Your structure is now consistent:"
echo ""
echo "meta-symoneural/"
echo "  ├── scripts/  (YOUR scripts)"
echo "  ├── contrib/  (YOUR contrib)"
echo "  └── recipes-core/..."
echo ""
echo "scripts/ (Upstream/Generic)"
echo "contrib/ (Upstream/Generic)"
echo "--------------------------------------------------"
