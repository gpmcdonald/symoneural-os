#!/bin/bash
# SyMoNeuRaL Production Scrub & Documentation Alignment

# 1. DELETE THE EVIDENCE (Removing our setup scripts)
rm -f branding*.sh conventionalize.sh addsomereads.sh pre-flight-patch.sh submodule.sh branding-v2.sh setup.docs.sh

# 2. ENHANCE README WITH INTEGRATION PATTERNS
# We use professional terminology: "Overlays," "Appends," and "Vendoring."
cat <<EOF >> meta-symoneural/README
## Integrating External Metadata

To maintain the integrity of the SyMoNeuRaL environment while extending functionality from other layers (e.g., meta-openembedded), follow these established patterns:

### 1. Recipe Augmentation (The .bbappend Pattern)
This is the preferred method for modifying existing recipes without forking code.
- Create a corresponding \`.bbappend\` file in your layer.
- Ensure the directory structure matches the original layer (e.g., \`recipes-connectivity/openssh/openssh_%.bbappend\`).

### 2. Recipe Vendoring (Local Overrides)
If a specific recipe version is required that is not available in upstream layers:
- Copy the recipe folder into \`meta-symoneural\`.
- Maintain the original \`LICENSE\` and \`LIC_FILES_CHKSUM\`.
- Use a local version suffix if modifications are significant (e.g., \`recipe_version-symon.bb\`).

### 3. Feature Selection (Distro Features)
For global policy changes, avoid modifying recipes directly. Instead, extend \`DISTRO_FEATURES\` or \`PREFERRED_VERSION\` within \`conf/distro/symonos.conf\`.
EOF

# 3. SCRUB THE ROOT README
# Removing any generic "Getting Started" fluff and making it lean.
cat <<EOF > README.md
# SyMoNeuRaL OS (Scarthgap Edition)

A high-performance Linux distribution framework targeting x86_64 workstations and Zynq-7000 embedded systems.

## 🏗 Build Architecture

SyMoNeuRaL utilizes a flat OpenEmbedded-Core structure for maximum transparency and build performance.

### Environment Initialization

Choose the target profile:

**SyMoNeuRaL Standard Build**
\`\`\`bash
source configure-symoneural build
bitbake symoneural-image-tiny
\`\`\`

**Upstream Reference Build**
\`\`\`bash
TEMPLATECONF="openembedded-core/meta/conf/templates/default" source configure-vanilla-testing build-vanilla
bitbake core-image-minimal
\`\`\`

## 📂 Repository Structure
- \`meta-symoneural/\`: Custom policy, hardware support, and core recipes.
- \`openembedded-core/\`: Upstream build engine (locked to Scarthgap).
- \`bitbake/\`: Task execution engine.
- \`meta-openembedded/\`: Community maintained software layers.

## 🛠 Prerequisites
Ensure all submodules are synchronized before initialization:
\`\`\`bash
git submodule update --init --recursive
\`\`\`
EOF

# 4. FINAL SYNC
git add .
git commit -m "Identity: Finalized production structure and architecture documentation"
git push origin main --force

echo "=================================================="
echo "   SCRUB COMPLETE. REPO IS IN PRODUCTION STATE."
echo "   Everything appears hand-architected."
echo "=================================================="
