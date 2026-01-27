#!/bin/bash
# SyMoNeuRaL Professional Integration: meta-poky

# 1. Automatically find the project root (calculates from scripts/ up to root)
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

echo "➜ Integrating meta-poky into: $ROOT_DIR"

# 2. Temporary clone to extract the layer
TEMP_POKY="/tmp/poky_extract"
rm -rf "$TEMP_POKY"
git clone --depth 1 -b scarthgap https://git.yoctoproject.org/poky "$TEMP_POKY"

# 3. Move meta-poky to root
cp -r "$TEMP_POKY/meta-poky" "$ROOT_DIR/"

# 4. Clean up
rm -rf "$TEMP_POKY"

# 5. Sync to GitHub
git add meta-poky/
git commit -m "Architecture: Integrated meta-poky layer (Scarthgap)"
git push origin main --force

echo "=================================================="
echo "   META-POKY IS NOW IN THE ROOT"
echo "=================================================="
