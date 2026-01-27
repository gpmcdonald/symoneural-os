#!/bin/bash
# SyMoNeuRaL Submodule Industrial Repair

# 1. Clear the "loose" folder and any broken index entries
git rm -rf --cached meta-poky openembedded-core
rm -rf meta-poky openembedded-core

# 2. Add them back as official submodules using GitHub mirror URLs
# (GitHub UI prefers .git suffixes for clickable links)
git submodule add -b scarthgap https://github.com/yoctoproject/poky.git meta-poky
git submodule add -b scarthgap https://github.com/openembedded/openembedded-core.git openembedded-core

# 3. Synchronize the Git internals
git submodule sync
git submodule update --init --recursive

# 4. Push the fixed "Blueprints" to GitHub
git add .gitmodules meta-poky openembedded-core
git commit -m "Architecture: Converted meta-poky to submodule and repaired OE-Core links"
git push origin main
