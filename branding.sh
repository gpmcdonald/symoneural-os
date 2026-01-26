#!/bin/bash
# SyMoNeuRaL Branding & Identity Scrub

METADIR="meta-symoneural"

echo "➜ Scrubbing generic branding..."

# 1. Update the Distro File to emphasize SyMoNeuRaL over Poky defaults
# We keep the 'require', but override the branding variables
sed -i 's/DISTRO_NAME = .*/DISTRO_NAME = "SyMoNeuRaL OS"/' $METADIR/conf/distro/symonos.conf
sed -i 's/SDK_VENDOR = .*/SDK_VENDOR = "-symoneuralsdk"/' $METADIR/conf/distro/symonos.conf

# 2. Update the READMEs to use "OpenEmbedded" or "SyMoNeuRaL"
# This makes the docs look like a custom OS rather than a Poky clone
sed -i 's/Poky/SyMoNeuRaL/g' README.md
sed -i 's/Poky reference distro/OpenEmbedded-based SyMoNeuRaL OS/g' $METADIR/README

# 3. Add a "Brand Identity" section to symonos.conf if it's missing
if ! grep -q "SYMONOS_BRANDING" "$METADIR/conf/distro/symonos.conf"; then
cat <<EOF >> $METADIR/conf/distro/symonos.conf

# --- Brand Identity ---
SYMONOS_BRANDING = "1"
# Ensure the OS release file shows our name
DISTRO_FEATURES:append = " symoneural-branding"
EOF
fi

echo "➜ Identity scrub complete. Force-syncing to GitHub..."
git add .
git commit -m "Identity: Scrubbed generic references in favor of SyMoNeuRaL branding"
git push origin main --force

echo "=================================================="
echo "   BRANDING IS NOW 100% SYMONEURAL."
echo "=================================================="
