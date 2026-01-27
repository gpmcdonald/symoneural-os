#!/bin/bash
# SyMoNeuRaL Professional Documentation Alignment

# 1. Automatically find the project root
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

echo "➜ Updating README.md in: $ROOT_DIR"

# 2. Rewrite the README to include meta-poky and the full architecture
cat <<EOF > README.md
# SyMoNeuRaL OS (Scarthgap Edition)

A flexible OpenEmbedded-based framework designed for custom Linux development. SyMoNeuRaL follows a Poky-style flat-root architecture, providing a complete ecosystem for distribution and hardware development.

## 🏗 Build Architecture

SyMoNeuRaL is structured as a modular framework. You can choose to use the SyMoNeuRaL policy or revert to a standard Reference Build at any time.

### Environment Initialization

**SyMoNeuRaL Environment**
Initializes with custom metadata, machine logic, and distro policy (Standard SyMoNeuRaL workflow).
\`\`\`bash
source configure-symoneural symoneural-build
bitbake symoneural-image-tiny
\`\`\`

**OpenEmbedded Reference Build**
Initializes a clean-room environment using upstream OE-Core samples. This operates exactly as a standalone OE-Core/Poky clone.
\`\`\`bash
TEMPLATECONF="meta/conf/templates/default" source configure-oe-ref oe-core-ref-build
bitbake core-image-minimal
\`\`\`

## 📂 Repository Structure
- \`meta-symoneural/\`: Custom metadata layer (Recipes, Machines, Distros).
- \`meta-poky/\`: The official Yocto Project reference distribution layer.
- \`openembedded-core/\`: Upstream build engine (Submodule).
- \`bitbake/\`: Task execution engine (Submodule).
- \`meta-*\`: Core metadata layers (meta, meta-skeleton, meta-selftest).
- \`scripts/\`: Utility and maintenance scripts.

## 🛠 Prerequisites
Synchronize submodules to populate the core engines:
\`\`\`bash
git submodule update --init --recursive
\`\`\`
EOF

# 3. Final Sync
git add README.md
git commit -m "Docs: Updated README to reflect meta-poky integration and flat-root architecture"
git push origin main --force

echo "=================================================="
echo "   DOCUMENTATION UPDATED"
echo "   Project matches the live file structure."
echo "=================================================="
