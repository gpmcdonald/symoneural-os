#!/bin/bash
# scripts/symon-portal.sh

# GUARD: Must be sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "❌ ERROR: This portal must be SOURCED, not executed."
    echo "Run: source ./scripts/symon-portal.sh"
    exit 1
fi

echo "🔍 Running quick environment audit..."
python3 ./scripts/symon-audit.py

while true; do
    echo -e "\n 󱁫 SyMoNeuRaL Management Portal"
    echo "1) Source SyMoNeuRaL (symon-build)"
    echo "2) Source Pure Poky (poky-build)"
    echo "3) Run Environment Audit"
    echo "4) Sync Workspace (Run symon-sync.sh)"
    echo "q) Exit"
    read -p "Select option: " opt
    case $opt in
        1)
            echo "Setting up SyMoNeuRaL build environment..."
            source ./symon-init-build-env symon-build
            echo "Done! Now in $(pwd) (symon-build env)"
            break
            ;;
        2)
            echo "Setting up pure Poky build environment..."
            cd sources/poky || { echo "❌ ERROR: sources/poky submodule missing/not initialized"; return 1; }
            source ./oe-init-build-env ../../poky-build
            cd - > /dev/null  # Optional: return to root after setup (but build env vars persist)
            echo "Done! Now in $(pwd) (poky-build env)"
            break
            ;;
        3)
            python3 ./scripts/symon-audit.py
            ;;
        4)
            ./symon-sync.sh || echo "⚠️  symon-sync.sh failed or not found"
            ;;
        q)
            return 0
            ;;
        *)
            echo "Invalid option, try again."
            ;;
    esac
done