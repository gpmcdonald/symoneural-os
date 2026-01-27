#!/bin/bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

echo "➜ Aligning meta-symoneural to standard Yocto structure..."

# 1. STANDARDIZE TEMPLATES
# Move 'symoneural-templates' to 'default' so it matches meta-poky behavior
if [ -d "meta-symoneural/conf/templates/symoneural-templates" ]; then
    echo "  - Renaming templates to standard 'default'..."
    mkdir -p meta-symoneural/conf/templates/default
    mv meta-symoneural/conf/templates/symoneural-templates/* meta-symoneural/conf/templates/default/ 2>/dev/null
    rm -rf meta-symoneural/conf/templates/symoneural-templates
fi

# 2. ENSURE LAYER.CONF MATCHES STANDARDS
echo "  - Regenerating meta-symoneural/conf/layer.conf..."
cat << 'EOF' > meta-symoneural/conf/layer.conf
# We have a conf and classes directory, add to BBPATH
BBPATH .= ":${LAYERDIR}"

# We have recipes-* directories, add to BBFILES
BBFILES += "${LAYERDIR}/recipes-*/*/*.bb \
            ${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "symoneural"
BBFILE_PATTERN_symoneural = "^${LAYERDIR}/"
BBFILE_PRIORITY_symoneural = "7"

LAYERDEPENDS_symoneural = "core openembedded-layer"
LAYERSERIES_COMPAT_symoneural = "scarthgap"
EOF

# 3. ENSURE BSP LAYER MATCHES
echo "  - Regenerating meta-symoneural-bsp/conf/layer.conf..."
mkdir -p meta-symoneural-bsp/conf
cat << 'EOF' > meta-symoneural-bsp/conf/layer.conf
BBPATH .= ":${LAYERDIR}"
BBFILES += "${LAYERDIR}/recipes-*/*/*.bb \
            ${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "symoneural-bsp"
BBFILE_PATTERN_symoneural-bsp = "^${LAYERDIR}/"
BBFILE_PRIORITY_symoneural-bsp = "6"

LAYERDEPENDS_symoneural-bsp = "core symoneural"
LAYERSERIES_COMPAT_symoneural-bsp = "scarthgap"
EOF

echo "✓ Structure aligned. meta-symoneural now matches meta-poky conventions."
