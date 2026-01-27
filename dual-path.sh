#!/bin/bash
# SyMoNeuRaL Dual-Entry Configuration Script

# 1. Create the SyMoNeuRaL (Custom) Entry symlink
ln -sf oe-init-build-env configure-symoneural

# 2. Create the Vanilla (Default) Entry symlink
ln -sf oe-init-build-env configure-vanilla-testing

# 3. Update the README with the "Dual-Path" Guide
cat <<EOF > README.md
# SyMoNeuRaL OS (Scarthgap Edition)

Integrated build environment for high-performance x86 workstations and Zynq-based embedded miners.

## 🚀 Getting Started

After cloning, choose your environment path:

### Option A: SyMoNeuRaL OS (Recommended)
Use this for the full experience, including custom branding, the 6.12 kernel, and NVIDIA support.
\`\`\`bash
source configure-symoneural build
bitbake symoneural-image-tiny
\`\`\`

### Option B: Vanilla OpenEmbedded (Testing/Debug)
Use this to build a standard, unbranded image for debugging base layer issues.
\`\`\`bash
TEMPLATECONF="" source configure-vanilla-testing build-vanilla
bitbake core-image-minimal
\`\`\`

## Project Layout
- \`meta-symoneural/\`: Custom metadata layer (Recipes, Machines, Distros).
- \`openembedded-core/\`: Core build system engine.
- \`bitbake/\`: Build tool.

## Hardware Support
- **Workstation:** symon-x86-workstation (NVIDIA RTX 5070 Ti)
- **Miner:** symoneural-miner-zynq (Xilinx Zynq-7010)
EOF

# 4. Sync to GitHub
git add configure-symoneural configure-vanilla-testing README.md
git commit -m "Identity: Established Dual-Entry build paths and updated README"
git push origin main --force

echo "=================================================="
echo "   DUAL-PATH ENTRY IS LIVE."
echo "   Repo: https://github.com/gpmcdonald/symoneural-os"
echo "=================================================="
