#!/bin/bash
# SYMoNeuRaL Magic Fix - Alignment Script

METADIR="meta-symoneural"

echo "➜ Performing Metadata Magic..."

# 1. ORGANIZE DIRECTORY STRUCTURE
mkdir -p $METADIR/conf/distro/include
mkdir -p $METADIR/conf/machine/include
mkdir -p $METADIR/recipes-core/images

# 2. FIX DISTRO INHERITANCE (symon-bleeding)
# Removing duplicates and ensuring it requires symonos.conf correctly
cat <<EOF > $METADIR/conf/distro/symon-bleeding.conf
require conf/distro/symonos.conf

DISTRO = "symon-bleeding"
DISTRO_NAME = "SyMoNeuRaL Bleeding Edge (Experimental)"

# Vendor-specific GPU enablement
require conf/distro/include/gpu-support-nvidia.inc

# Overwrite Kernel for Bleeding Edge
# Note: Ensure your layers have 6.12 recipes available
PREFERRED_VERSION_linux-yocto = "6.12%"
PREFERRED_VERSION_linux-yocto-rt = "6.12%"
EOF

# 3. FIX MACHINE AUTHORITY (symon-x86-workstation)
# Making it a clean architectural definition
cat <<EOF > $METADIR/conf/machine/symon-x86-workstation.conf
require conf/machine/genericx86-64.conf

# Hardware Identity
MACHINE = "symon-x86-workstation"

# Branding and Boot
SYMON_SPLASH_FILE = "workstation_splash.png"

# Hardware Capabilities (Modules handled by GPU include in Distro)
MACHINE_FEATURES += "pci pcie efi screen x86"
EOF

# 4. FIX IMAGE NAMING CONVENTION
# Moving from tiny-miner to a standard flavor-based image
if [ -f $METADIR/recipes-core/images/symoneural-tiny-miner.bb ]; then
    mv $METADIR/recipes-core/images/symoneural-tiny-miner.bb $METADIR/recipes-core/images/symoneural-image-tiny.bb
fi

# 5. SANITIZE HDF PATHS
# Removing LAYERDIR dependency in favor of metadata-relative paths
sed -i 's|\${LAYERDIR}/recipes-bsp/hw-design/|recipes-bsp/hw-design/|g' $METADIR/conf/machine/symoneural-miner-zynq.conf

echo "➜ Magic Complete. Syncing to GitHub..."
git add .
git commit -m "Standardization: Applied Scarthgap Metadata Convention (Distro/Machine/Image)"
git push origin main

echo "=================================================="
echo "   RE-PO SYNCED AND STANDARDIZED."
echo "   Go take that break! You've earned it."
echo "=================================================="
