#!/bin/bash
# SyMoNeuRaL Architectural Realignment: Precision Sync

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

echo "➜ Auditing and Refining Layer Structure..."

# 1. Ensure BSP structure exists
mkdir -p meta-symoneural-bsp/conf/machine
mkdir -p meta-symoneural-bsp/recipes-kernel
mkdir -p meta-symoneural-bsp/recipes-bsp

# 2. Idempotent Move: Only move if the source exists
if [ -d "meta-symoneural/conf/machine" ] && [ "$(ls -A meta-symoneural/conf/machine)" ]; then
    echo "  -> Moving machine configs to BSP layer..."
    mv meta-symoneural/conf/machine/* meta-symoneural-bsp/conf/machine/
    rm -rf meta-symoneural/conf/machine
fi

# 3. Precision Distro Layer (meta-symoneural)
# This layer should have a higher priority than the BSP
cat <<EOF > meta-symoneural/conf/layer.conf
BBPATH .= ":\${LAYERDIR}"
BBFILES += "\${LAYERDIR}/recipes-*/*/*.bb \\
            \${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "symoneural"
BBFILE_PATTERN_symoneural = "^\${LAYERDIR}/"
BBFILE_PRIORITY_symoneural = "7"
LAYERVERSION_symoneural = "1"
LAYERSERIES_COMPAT_symoneural = "scarthgap"
EOF

# 4. Precision BSP Layer (meta-symoneural-bsp)
cat <<EOF > meta-symoneural-bsp/conf/layer.conf
BBPATH .= ":\${LAYERDIR}"
BBFILES += "\${LAYERDIR}/recipes-*/*/*.bb \\
            \${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "symoneural-bsp"
BBFILE_PATTERN_symoneural-bsp = "^\${LAYERDIR}/"
BBFILE_PRIORITY_symoneural-bsp = "6"
LAYERVERSION_symoneural-bsp = "1"
LAYERSERIES_COMPAT_symoneural-bsp = "scarthgap"
EOF

# 5. Finalize Documentation
# Clean up duplicate entries if they exist
grep -q "meta-symoneural-bsp" README.md || sed -i '/meta-symoneural\//a - `meta-symoneural-bsp/`: Hardware abstraction layer (Machine configs & BSP).' README.md

# 6. Push
git add meta-symoneural meta-symoneural-bsp README.md
git commit -m "Architecture: Precision realignment of Distro (7) and BSP (6) layers"
git push origin main

echo "=================================================="
echo "   RE-ALIGNMENT COMPLETE"
echo "   Policy (Priority 7): meta-symoneural"
echo "   Hardware (Priority 6): meta-symoneural-bsp"
echo "=================================================="
