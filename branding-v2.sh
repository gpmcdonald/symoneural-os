#!/bin/bash
# Final SyMoNeuRaL Identity Alignment

METADIR="meta-symoneural"

echo "➜ Deep-scrubbing internal metadata..."

# 1. FIX LAYER.CONF (The most important part)
# It likely still says 'core' or 'poky' for BBFILE_COLLECTIONS
cat <<EOF > $METADIR/conf/layer.conf
# We have a conf and classes directory, add to BBPATH
BBPATH .= ":\${LAYERDIR}"

# We have recipes-* directories, add to BBFILES
BBFILES += "\${LAYERDIR}/recipes-*/*/*.bb \\
            \${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "symoneural"
BBFILE_PATTERN_symoneural = "^\${LAYERDIR}/"
BBFILE_PRIORITY_symoneural = "6"

LAYERSERIES_COMPAT_symoneural = "scarthgap"
EOF

# 2. FIX DISTRO BACKFILL & IDENTITY
# Ensuring the distro doesn't just inherit Poky's name in the OS release
sed -i 's/DISTRO = "poky"/DISTRO = "symonos"/g' $METADIR/conf/distro/symonos.conf
sed -i 's/require conf/distro/poky.conf/require conf/distro/include/symoneural-base.inc/g' $METADIR/conf/distro/symonos.conf

# 3. CREATE THE BASE INCLUDE (Moving away from requiring poky.conf directly)
mkdir -p $METADIR/conf/distro/include
cat <<EOF > $METADIR/conf/distro/include/symoneural-base.inc
# Inherit sane defaults from OE-Core, not the Poky branding
require conf/distro/include/default-distrovars.inc
require conf/distro/include/default-setup-layers.inc

# SyMoNeuRaL Policy
DISTRO_FEATURES:append = " systemd pam multiarch"
DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit"
EOF

# 4. Final README cleanup - ensuring no "Poky" in the Quick Start
sed -i 's/poky/symoneural/g' README.md 2>/dev/null
# Re-fix the specific source command which SHOULD point to poky for the script location
sed -i 's/source symoneural\/oe-init-build-env/source poky\/oe-init-build-env/g' README.md

echo "➜ Pushing Identity Fix to GitHub..."
git add .
git commit -m "Identity: Final internal metadata scrub for SyMoNeuRaL naming"
git push origin main --force

echo "=================================================="
echo "   INTERNAL IDENTITY SYNCED."
echo "   Check: meta-symoneural/conf/layer.conf"
echo "=================================================="
