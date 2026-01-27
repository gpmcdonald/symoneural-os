#!/bin/bash
# SyMoNeuRaL Professional Alignment
# This script is designed to be run from the project root: ./scripts/professionalize.sh

# 1. Automatically find the project root relative to this script
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

echo "➜ Running from root: $ROOT_DIR"

# 2. Now all your commands work exactly as before because we CD'd to the root
mkdir -p legal docs scripts
mv LICENSE* legal/ 2>/dev/null
mv COPYING* legal/ 2>/dev/null
mv SECURITY.md docs/ 2>/dev/null
mv MEMORIAM docs/ 2>/dev/null
mv README.qemu.md docs/ 2>/dev/null

# 3. Clean up other scripts (except this one)
find . -maxdepth 1 -name "*.sh" ! -name "professionalize.sh" -exec mv {} scripts/ \; 2>/dev/null

# ... (rest of the maintainer and symlink logic from before) ...

echo "=================================================="
echo "   PROJECT PROFESSIONALIZATION COMPLETE"
echo "=================================================="
