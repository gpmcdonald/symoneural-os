#!/bin/bash
# SyMoNeuRaL Template & Path Correction

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

echo "➜ Correcting template redirection..."

# 1. Update the OE-Core Reference template link
# This ensures it uses the upstream samples, NOT your custom ones
rm -f configure-oe-ref
ln -sf openembedded-core/oe-init-build-env configure-oe-ref

# 2. Update the SyMoNeuRaL template link
rm -f configure-symoneural
ln -sf oe-init-build-env configure-symoneural

# 3. Create a clean OE-Core template pointer
# Upstream OE-Core samples are in openembedded-core/meta/conf/templates/default
OE_TEMPLATE_DIR="$ROOT_DIR/openembedded-core/meta/conf/templates/default"
SYM_TEMPLATE_DIR="$ROOT_DIR/meta-symoneural/conf/templates/default"

# 4. Verify the directories exist
if [ ! -d "$OE_TEMPLATE_DIR" ]; then echo "Error: OE templates missing!"; fi
if [ ! -d "$SYM_TEMPLATE_DIR" ]; then echo "Error: SymoNeuRaL templates missing!"; fi

echo "➜ Pushing logic updates..."
git add .
git commit -m "Fix: Explicit template separation for Reference vs Custom builds"
git push origin main
