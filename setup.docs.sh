#!/bin/bash
set -e

echo "=================================================="
echo "   SymoNeuRaL Documentation & Folder Setup"
echo "=================================================="

# 1. Create Custom Directories
# --------------------------------------------------
echo "[1/3] Creating custom script directories..."

# 'scripts-symoneural': For your reliable CI/CD and build wrappers
mkdir -p scripts-symoneural
cat <<EOF > scripts-symoneural/README.md
# SymoNeuRaL Scripts
Place your custom build wrappers, CI/CD pipelines, and environment setup tools here.
**Do not** modify the upstream \`../scripts\` directory; put your overrides here.
EOF

# Create a sample "Build Wrapper" script as an example
cat <<EOF > scripts-symoneural/build-all.sh
#!/bin/bash
# Example: A wrapper to build your main image
source ../oe-init-build-env ../build
bitbake symoneural
EOF
chmod +x scripts-symoneural/build-all.sh


# 'contrib-symoneural': For experimental tools or messy hacks
mkdir -p contrib-symoneural
cat <<EOF > contrib-symoneural/README.md
# SymoNeuRaL Contrib
Place experimental tools, one-off hacks, or third-party utilities here that are not yet ready for production.
EOF

# 2. Generate the Main Project README
# --------------------------------------------------
echo "[2/3] Generating Project Manual (README.md)..."

cat <<EOF > README.md
# SymoNeuRaL OS

**SymoNeuRaL** is a custom embedded Linux distribution built on the Yocto Project (OpenEmbedded).

## 📂 Repository Structure

This repository follows the "Combo-Layer" pattern. It contains both the build engine and the custom metadata.

### 🔴 Your Code (Edit These)
* **\`meta-symoneural/\`**: The heart of the OS. Contains recipes, machine configs (Alienware/RPi), and distro policies.
* **\`scripts-symoneural/\`**: Custom management scripts (e.g., build wrappers, deployment tools).
* **\`contrib-symoneural/\`**: Experimental tools and one-off hacks.

### 🟡 Build Artifacts (Ignored by Git)
* **\`build/\`**: Generated output. Contains disk images, packages, and temporary compilation files.
* **\`downloads/\`**: Source code tarballs downloaded from the internet.

### 🔵 Vendor/Upstream (DO NOT EDIT)
* **\`bitbake/\`**: The build engine (Task scheduler).
* **\`meta/\`**: OpenEmbedded Core (Standard C library, GCC, core Linux tools).
* **\`meta-openembedded/\`**: Community layers (Networking, Python, UI).
* **\`meta-clang/\`**: LLVM compiler infrastructure.
* **\`scripts/\`**: Standard Yocto utilities (\`runqemu\`, \`devtool\`, \`yocto-check-layer\`).
* **\`contrib/\`**: Upstream community extras (Tab completion, vim syntax, etc.).

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

3. **Run Custom Scripts**
   Use your custom wrappers instead of manual commands:
   \`\`\`bash
   ./scripts-symoneural/build-all.sh
   \`\`\`

## Supported Hardware
* **Alienware R11** (NVIDIA RTX 5070 Ti)
* **Raspberry Pi 4** (64-bit)
* **Generic x86-64** (UEFI)

EOF

# 3. Cleanup
# --------------------------------------------------
echo "[3/3] Finalizing..."
# Remove this setup script itself if you want, or keep it.
# rm -- "\$0"

echo "--------------------------------------------------"
echo "SUCCESS. Your project structure is now:"
echo ""
ls -d */ | grep -v "meta-" | grep -v "build"
echo "meta-symoneural/"
echo "README.md"
echo "--------------------------------------------------"
