#!/bin/bash
# SyMoNeuRaL Submodule Fix

echo "➜ Cleaning up embedded repositories..."

# 1. Remove the "hollow" index entries Git warned about
git rm -r --cached bitbake meta-openembedded meta-clang 2>/dev/null

# 2. Add them back as proper Git Submodules (Scarthgap branch)
echo "➜ Adding formal submodules..."

git submodule add -b scarthgap https://github.com/openembedded/bitbake.git bitbake
git submodule add -b scarthgap https://github.com/openembedded/meta-openembedded.git meta-openembedded
git submodule add -b scarthgap https://github.com/kraj/meta-clang.git meta-clang

# 3. Initialize and sync
git submodule update --init --recursive

# 4. Final Push
git add .gitmodules bitbake meta-openembedded meta-clang
git commit -m "Identity: Converted embedded layers to proper Git Submodules"
git push origin main

echo "=================================================="
echo "   SUBMODULES FINALIZED."
echo "   Your repo is now portable and professional."
echo "=================================================="
