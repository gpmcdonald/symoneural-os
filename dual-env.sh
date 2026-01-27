#!/bin/bash
# SyMoNeuRaL Final Alignment: Dual-Path Convention

echo "➜ Establishing obvious entry points..."

# 1. Create the SyMoNeuRaL (Custom) Entry
ln -sf oe-init-build-env configure-symoneural

# 2. Create the Vanilla (Standard OE) Entry
ln -sf oe-init-build-env configure-vanilla-testing

# 3. Update the README with explicit instructions for both paths
cat <<EOF > README.md
# SyMoNeuRaL OS (Scarthgap Edition)

Integrated build environment for high-performance x86 workstations and Zynq-based embedded miners.

## 🚀 Getting Started

Choose your environment path based on your requirements:

### Option A: SyMoNeuRaL OS (Recommended)
Use this for the custom SyMoNeuRaL identity, 6.12 kernel, and hardware-specific optimizations.
- **Config source:** Uses \`meta-symoneural/conf/templates/default\`
\`\`\`bash
source configure-symoneural build
bitbake symoneural-image-tiny
\`\`\`

### Option B: Vanilla OpenEmbedded (Standard)
Use this to get a 100% standard OpenEmbedded environment. This generates the full, annotated upstream \`local.conf\` with default \`nodistro\` settings.
- **Config source:** Uses \`openembedded-core/meta/conf/templates/default\`
\`\`\`bash
TEMPLATECONF="openembedded-core/meta/conf/templates/default" source configure-vanilla-testing build-vanilla
bitbake core-image-minimal
\`\`\`

## Project Layout
- \`meta-symoneural/\`: Custom metadata layer (Recipes, Machines, Distros).
- \`openembedded-core/\`: Core build system engine (Submodule).
- \`bitbake/\`: Build tool (Submodule).

## Hardware Support
- **Workstation:** symon-x86-workstation (NVIDIA RTX 5070 Ti)
- **Miner:** symoneural-miner-zynq (Xilinx Zynq-7010)
EOF

# 4. Sync and Push
git add configure-symoneural configure-vanilla-testing README.md
git commit -m "Convention: Finalized Dual-Entry paths and Master README"
git push origin main --force

echo "=================================================="
echo "   REMAINDER OF REPO IS NOW SELF-DOCUMENTING."
echo "   Ready for all test scenarios."
echo "=================================================="
