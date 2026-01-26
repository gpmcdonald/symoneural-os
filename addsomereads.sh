#!/bin/bash
# SyMoNeuRaL Documentation Button-Up Script

METADIR="meta-symoneural"

echo "➜ Generating Layer and Component READMEs..."

# 1. Root Project README (The Master Guide)
cat <<EOF > README.md
# SyMoNeuRaL OS (Scarthgap Edition)

Integrated build environment for high-performance x86 workstations and Zynq-based embedded miners.

## Project Layout
- \`meta-symoneural/\`: Custom metadata layer (Recipes, Machines, Distros).
- \`poky/\`: Core Yocto Project build system.
- \`build/\`: Local build output (not tracked).

## Building
1. \`source poky/oe-init-build-env build\`
2. Set your environment:
   - Workstation: \`export MACHINE=symon-x86-workstation\` / \`export DISTRO=symon-bleeding\`
   - Miner: \`export MACHINE=symoneural-miner-zynq\` / \`export DISTRO=symonos\`
3. \`bitbake symoneural-image-tiny\`
EOF

# 2. Update README.qemu.md (The Testing Guide)
cat <<EOF > README.qemu.md
# SyMoNeuRaL QEMU Testing

Use these commands to test images on your Alienware R11 before flashing hardware.

## Running x86 Workstation
\`runqemu symon-x86-workstation nographic\`

## Running Zynq Miner (Emulated)
\`runqemu symoneural-miner-zynq qemuparams="-m 1024"\`

**Note:** GPU acceleration is not available in standard QEMU; use these for logic and init-script testing only.
EOF

# 3. BSP README (The Hardware Handoff)
mkdir -p $METADIR/recipes-bsp/hw-design
cat <<EOF > $METADIR/recipes-bsp/hw-design/README.md
# BSP Hardware Design
This directory contains the handoff files from hardware engineering.

- **Miner:** Expects \`miner_top.xsa\` in \`files/\` for the Zynq 7010 target.
- **Workstation:** Managed via kernel modules and \`gpu-support-nvidia.inc\`.
EOF

# 4. Images README (The Flavor Guide)
mkdir -p $METADIR/recipes-core/images
cat <<EOF > $METADIR/recipes-core/images/README.md
# SyMoNeuRaL Image Recipes
- \`symoneural-image-tiny.bb\`: The minimalist base image for all platforms.
- Add additional image recipes here for 'Full' or 'Server' variants.
EOF

# 5. Core Layer README (Standard OE Format)
cat <<EOF > $METADIR/README
meta-symoneural
===============
Main metadata layer for SyMoNeuRaL OS.

Dependencies:
- poky (scarthgap)
- meta-openembedded (oe, python, networking)

Hardware:
- symon-x86-workstation (RTX 50-series)
- symoneural-miner-zynq (Zynq 7010)
EOF

echo "➜ Documentation synced. Pushing to GitHub..."
git add .
git commit -m "Docs: Finalized README structure for root, QEMU, and BSP"
git push origin main

echo "=================================================="
echo "   PROJECT BUTTONED UP FOR TONIGHT."
echo "   GitHub is synced. Sleep well, Garrett."
echo "=================================================="
