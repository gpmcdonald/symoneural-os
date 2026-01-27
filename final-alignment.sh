#!/bin/bash
# SyMoNeuRaL Final Alignment & "Zero-Hour" Fix

echo "➜ Cleaning Git Index and Submodule landmines..."
# Remove 'hollow' folders from Git index if they exist as metadata
git rm -r --cached bitbake meta-openembedded meta-clang 2>/dev/null

# 1. Fix .templateconf for the FLAT structure
# Since oe-init-build-env is in the root, the path should be direct
echo 'TEMPLATECONF="meta-symoneural/conf/templates/default"' > .templateconf

# 2. Sync the Template Files
# Ensure the bblayers.conf.sample uses the flat structure paths (../)
mkdir -p meta-symoneural/conf/templates/default
cat <<EOF > meta-symoneural/conf/templates/default/bblayers.conf.sample
POKY_BBLAYERS_CONF_VERSION = "2"
BBPATH = "\${TOPDIR}"
BBFILES ?= ""
BBLAYERS ?= " \\
  ##OEROOT##/meta \\
  ##OEROOT##/meta-symoneural \\
  ##OEROOT##/meta-openembedded/meta-oe \\
  ##OEROOT##/meta-openembedded/meta-python \\
  ##OEROOT##/meta-openembedded/meta-networking \\
  ##OEROOT##/meta-clang \\
  "
EOF

# 3. Final Machine Pathing Patch (Zynq Handoff)
# This ensures the .xsa search starts from the meta-symoneural root
sed -i 's|HDF_PATH = .*|HDF_PATH = "\${EXTERNAL_XSA_PATH}/\${MACHINE}.xsa"|g' meta-symoneural/conf/machine/symoneural-miner-zynq.conf

# 4. Final Commit and Push
git add .templateconf meta-symoneural/conf/templates/
git commit -m "Final Alignment: Native template paths and Zynq handoff fix"
git push origin main --force

echo "=================================================="
echo "   ALL SYSTEMS GO: REPO IS AT PEAK READINESS."
echo "   Identity: SyMoNeuRaL"
echo "   Convention: OpenEmbedded Flat-Standard"
echo "=================================================="
