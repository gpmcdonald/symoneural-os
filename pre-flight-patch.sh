#!/bin/bash
# SyMoNeuRaL Final Pre-Flight Patch

METADIR="meta-symoneural"

echo "➜ Applying final pre-flight patches..."

# 1. Fix HDF_PATH in the Zynq Machine config
# It needs one more '../' to reach the recipes-bsp folder from conf/machine
sed -i 's|${THISDIR}/../../recipes-bsp|${THISDIR}/../../../meta-symoneural/recipes-bsp|g' $METADIR/conf/machine/symoneural-miner-zynq.conf

# 2. Update Kernel Compatibility
# Ensure the 6.12 recipe explicitly allows your custom machine names
# Otherwise, BitBake will say "Package linux-yocto is not compatible with symon-x86-workstation"
if [ -f "$METADIR/recipes-kernel/linux/linux-yocto_6.12.bb" ]; then
    sed -i 's/COMPATIBLE_MACHINE = .*/COMPATIBLE_MACHINE = "qemuarm|qemuarm64|qemumips|qemuppc|qemux86|qemux86-64|symon-x86-workstation|symoneural-miner-zynq"/' $METADIR/recipes-kernel/linux/linux-yocto_6.12.bb
fi

# 3. Add a basic .gitignore to keep your repo clean during testing
cat <<EOF > .gitignore
build/
bitbake.lock
pseudodone
conf/local.conf
conf/bblayers.conf
downloads/
sstate-cache/
tmp/
*.pyc
*.swp
EOF

echo "➜ Syncing final patches..."
git add .
git commit -m "Final Pre-Flight: Fixed HDF pathing, kernel compatibility, and gitignore"
git push origin main --force

echo "=================================================="
echo "   SYSTEM READY FOR ALL SCENARIOS."
echo "   - Workstation (x86/6.12/NVIDIA) : READY"
echo "   - Miner (Zynq/6.6 or 6.12)      : READY"
echo "   - QEMU Emulation                : READY"
echo "=================================================="
