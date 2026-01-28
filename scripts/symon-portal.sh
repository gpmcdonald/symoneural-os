#!/bin/bash
# scripts/symon-portal.sh

# GUARD: Check if the script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "❌ ERROR: This portal must be SOURCED, not executed."
    echo "Run: source ./scripts/symon-portal.sh"
    exit 1
fi

while true; do
    echo -e "\n 󱁫 SyMoNeuRaL Management Portal"
    echo "1) Source SyMoNeuRaL (symon-build)"
    echo "2) Source Pure Poky (poky-build)"
    echo "3) Run Environment Audit"
    echo "4) Sync Workspace (Run symon-sync.sh)"
    echo "q) Exit"
    read -p "Select option: " opt
    case $opt in
        1) source ./symon-init-build-env symon-build; break ;;
        2) cd sources/openembedded-core; source ./oe-init-build-env ../../poky-build; cd ../..; break ;;
        3) python3 ./scripts/symon-audit.py ;;
        4) ./symon-sync.sh ;;
        q) return 0 ;;
    esac
done
