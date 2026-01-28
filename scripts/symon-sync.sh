#!/bin/bash
# symon-sync.sh: SyMoNeuRaL Repository & Submodule Maintenance
# Enhanced for Scarthgap migration: enforce branches, use manifest.json for custom layers

set -e  # Exit on error

PROJECT_ROOT="$(pwd)"
echo " 󱁫 SyMoNeuRaL Maintenance: Syncing Workspace to Scarthgap..."

# 0. Sanity check
if [ ! -f "manifest.json" ] || [ ! -d "sources" ]; then
    echo "❌ ERROR: Must run from repo root (where manifest.json and sources/ exist)"
    exit 1
fi

# 1. Submodule Health Check + Branch Enforcement
echo "📡 Initializing & Updating Submodules..."
git submodule update --init --recursive

echo "🔧 Enforcing Scarthgap branches on Yocto core submodules..."
YOCTO_BRANCH="scarthgap"

for submodule in bitbake openembedded-core meta-openembedded poky meta-clang meta-xilinx meta-arm meta-yocto; do
    path="sources/$submodule"
    if [ -d "$path" ]; then
        current_branch=$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
        if [ "$current_branch" != "$YOCTO_BRANCH" ]; then
            echo "→ Switching $submodule to $YOCTO_BRANCH (was $current_branch)"
            git -C "$path" fetch origin
            git -C "$path" checkout "$YOCTO_BRANCH" || {
                echo "⚠️ $submodule has no $YOCTO_BRANCH branch (using latest fetch)"
                git -C "$path" checkout FETCH_HEAD
            }
            git -C "$path" pull --rebase origin "$YOCTO_BRANCH" || echo "  (pull skipped if detached)"
        else
            echo "✓ $submodule already on $YOCTO_BRANCH"
            git -C "$path" pull --rebase origin "$YOCTO_BRANCH"
        fi
    else
        echo "⚠️ $path not found — submodule missing?"
    fi
done

# 2. Custom Layers from manifest.json
echo "🔧 Syncing custom layers from manifest.json..."
if command -v jq >/dev/null; then
    jq -r '.layers[] | "\(.name) \(.branch)"' manifest.json | while read -r layer branch; do
        if [ -d "$layer" ]; then
            echo "→ Ensuring $layer on branch $branch"
            git -C "$layer" checkout "$branch" 2>/dev/null || echo "  (checkout failed — maybe not git repo)"
            git -C "$layer" pull --rebase origin "$branch" || true
        fi
    done
else
    # Fallback: hardcoded from manifest
    for layer_branch in "meta-neural:scarthgap" "meta-symon:main" "meta-symoneural-bsp:main"; do
        layer=${layer_branch%%:*}
        branch=${layer_branch#*:}
        if [ -d "$layer" ]; then
            echo "→ Ensuring $layer on $branch (hardcoded fallback)"
            git -C "$layer" checkout "$branch" 2>/dev/null || true
            git -C "$layer" pull --rebase origin "$branch" || true
        fi
    done
fi

# 3. Cleanup Orphan BitBake Locks
echo "🧹 Cleaning up lock files in build dirs..."
for d in build symon-build poky-build */build */tmp */sstate-cache; do
    if [ -d "$d" ]; then
        find "$d/" -name "*.lock" -delete 2>/dev/null || true
    fi
done

# 4. Validation & Anchors
echo "⚓ Verifying Project Anchors..."
if [ ! -s ".templateconf" ]; then
    echo "TEMPLATECONF=\${TEMPLATECONF:-meta-symon/conf/templates/default}" > .templateconf
    echo "✓ Regenerated .templateconf"
fi

# 5. Permission Sweep
echo "🔐 Fixing script permissions..."
chmod +x symon-init-build-env scripts/*.sh scripts/*.py 2>/dev/null || true
find . -type d -name "scripts" -exec chmod +x {}/**/*.sh {}/*.py \; 2>/dev/null || true

echo "--------------------------------------------------------"
echo "✓ Workspace Synced (Scarthgap-aligned)."
echo ""
echo "Quick checks:"
echo "  python3 scripts/symon-audit.py"
echo "  source ./scripts/symon-portal.sh   → choose option 1 or 2"
echo "--------------------------------------------------------"