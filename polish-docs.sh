#!/bin/bash
# SyMoNeuRaL README Update: Submodule Instructions

# We'll insert the setup section right after the Getting Started header
sed -i '/## 🚀 Getting Started/a \
\
### 1. First-Time Setup (Crucial)\
Before building, you must initialize the submodules to download the core engines:\
```bash\
git submodule update --init --recursive\
```' README.md

# Sync to GitHub
git add README.md
git commit -m "Docs: Added crucial submodule initialization step"
git push origin main --force

echo "=================================================="
echo "   README UPDATED WITH SETUP INSTRUCTIONS."
echo "=================================================="
