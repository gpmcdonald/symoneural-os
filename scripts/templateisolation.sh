#!/bin/bash
# SyMoNeuRaL Template Isolation: Sudo Edition

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

echo "➜ Isolating templates and cleaning poisoned build dirs..."

# 1. Use sudo to nuke the build directory that's ignoring your vars
sudo rm -rf oe-core-ref-build

# 2. Rename custom templates to prevent "auto-detection"
# This forces the build script to stop 'guessing' and use OE-Core defaults
if [ -d "meta-symoneural/conf/templates/default" ]; then
    mv meta-symoneural/conf/templates/default meta-symoneural/conf/templates/symoneural-templates
fi

# 3. Fix the README to show the new explicit paths
sed -i 's|meta-symoneural/conf/templates/default|meta-symoneural/conf/templates/symoneural-templates|g' README.md

# 4. Sync to GitHub
git add .
git commit -m "Architecture: Isolated templates and cleaned build cache with sudo"
git push origin main

echo "=================================================="
echo "   RE-ALIGNMENT COMPLETE"
echo "   Reference Build path is now CLEAN."
echo "=================================================="
