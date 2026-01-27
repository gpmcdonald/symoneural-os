#!/bin/bash

# Define the backtick for safe generation
TIC='```'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

echo "Restoring full README.md..."

# Note: We use EOF (unquoted) to allow the ${TIC} variable to expand
cat << EOF > README.md
# SyMoNeuRaL OS (Scarthgap Edition)

A professional OpenEmbedded-based framework following the Poky flat-root architecture. This repository separates OS Policy from Hardware BSP and provides two distinct build pathways. This environment is configured for **Debian 13** and is designed to be **untunneled**.

## 🏗 Build Architecture

### 1. SyMoNeuRaL Environment (Custom OS)
Initializes using custom branding, policies, and hardware optimizations for the **RTX 5070 Ti**.
- **Initialize:** \`synapse\` (Select Option 1 or 2)
- **Target:** \`bitbake symoneural-image-base\`

### 2. OpenEmbedded Reference Build (Clean Room)
Initializes a clean, upstream environment using only core metadata.
- **Initialize:** \`synapse\` (Select Option 3)
- **Target:** \`bitbake core-image-minimal\`

## ⚡ The Synapse Portal

The \`synapse\` portal is the intelligent management tool for this repository. It handles submodule synchronization, environment isolation, and hardware-specific initializations.

### Usage
${TIC}bash
# Run directly
./scripts/synapse.sh

# Optional: Install to path
./scripts/synapse.sh --install

# Launch globally
synapse

# To remove global command
synapse --remove
${TIC}

## 📂 Repository Structure

* **meta-symoneural/**: OS Policy & Distro layer (Priority 7).
* **meta-symoneural-bsp/**: Hardware Abstraction layer (Priority 6).
* **meta-poky/**: Yocto Project reference distribution (Submodule).
* **openembedded-core/**: Upstream build engine (Submodule).
* **bitbake/**: Task execution engine (Submodule).
* **scripts/**: Maintenance and alignment utilities.

## 🛠 Setup

Synchronize submodules before first use (Synapse does this automatically):
${TIC}bash
git submodule update --init --recursive
${TIC}

---
**Maintained by:** Garrett Parker Mcdonald
**Status:** Scarthgap Release 1.0 (Active Development)
EOF

echo "Pushing changes to GitHub..."
git add README.md
git commit -m "Docs: Complete README restoration with Debian 13 specs"
git push origin main

echo "Done."
