#!/usr/bin/env python3
import subprocess
import os
import sys

def get_git_info(path):
    try:
        branch = subprocess.check_output(["git", "-C", path, "rev-parse", "--abbrev-ref", "HEAD"], text=True).strip()
        sha = subprocess.check_output(["git", "-C", path, "rev-parse", "HEAD"], text=True).strip()
        return branch, sha
    except Exception:
        return "Unknown", "N/A"

def get_layer_compat(layer_path):
    layer_conf = os.path.join(layer_path, "conf/layer.conf")
    if not os.path.exists(layer_conf):
        return []
    with open(layer_conf, 'r') as f:
        for line in f:
            if "LAYERSERIES_COMPAT" in line:
                return line.split("=")[-1].replace('"', '').strip().split()
    return []

def main():
    root = os.environ.get("OEROOT", os.getcwd())
    layers = {
        "Core": os.path.join(root, "sources/openembedded-core"),
        "BSP": os.path.join(root, "meta-symoneural-bsp"),
        "Engine": os.path.join(root, "meta-neural"),
        "Distro": os.path.join(root, "meta-symon")
    }

    oe_branch, _ = get_git_info(layers["Core"])

    print(f"\n[ SYMON OS ARCHITECTURE AUDIT ]")
    print("-" * 40)
    for name, path in layers.items():
        branch, sha = get_git_info(path)
        compat = get_layer_compat(path) if name != "Core" else [oe_branch]
        status = "✓" if (name == "Core" or oe_branch in compat) else "❌"
        print(f"{status} {name:6} | Branch: {branch:10} | {sha[:8]}")

    if any(oe_branch not in get_layer_compat(layers[n]) for n in ["BSP", "Engine", "Distro"]):
        print(f"\n⚠️  ALIGNMENT ERROR: One or more layers do not support '{oe_branch}'.")

if __name__ == "__main__":
    main()
