#!/bin/bash
# symon-sync.sh: SyMoNeuRaL Repository & Submodule Maintenance

PROJECT_ROOT="$(pwd)"
echo " 󱁫 SyMoNeuRaL Maintenance: Syncing Workspace..."

# 1. Submodule Health Check
echo "📡 Refreshing Submodules..."
git submodule update --init --recursive

# 2. Cleanup Orphan BitBake Locks across all build folders
echo "扫 Cleaning up lock files..."
for d in build symon-build poky-build; do
    if [ -d "$d" ]; then
        find "$d/" -name "*.lock" -delete 2>/dev/null
    fi
done

# 3. Validation
echo "⚓ Verifying Project Anchors..."
if [ ! -f ".templateconf" ]; then
    echo "TEMPLATECONF=\${TEMPLATECONF:-meta-symon/conf/templates/default}" > .templateconf
    echo "✓ Regenerated .templateconf"
fi

# 4. Permission Sweep
chmod +x symon-init-build-env scripts/*.sh scripts/*.py 2>/dev/null

echo "--------------------------------------------------------"
echo "✓ Workspace Synced."
echo ""
echo "To enter the build environment, you MUST SOURCE the portal:"
echo "    source ./scripts/symon-portal.sh"
echo "--------------------------------------------------------"
