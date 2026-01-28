#!/usr/bin/env python3
import os, subprocess
def audit():
    print(" 󱁫 SyMoNeuRaL Audit Engine")
    subs = {"OE-Core": "sources/openembedded-core", "BitBake": "sources/bitbake", "Meta-Neural": "meta-neural"}
    print("-" * 30)
    for name, path in subs.items():
        if os.path.exists(path):
            branch = subprocess.check_output(["git", "-C", path, "rev-parse", "--abbrev-ref", "HEAD"], stderr=subprocess.DEVNULL).decode().strip()
            print(f"{'✓' if 'scarthgap' in branch or 'main' in branch else '⚠️'} {name:12}: {branch}")
        else:
            print(f"❌ {name:12}: MISSING")
if __name__ == "__main__": audit()
