#!/usr/bin/env python3
import os, subprocess, sys, json

def get_git_info(path):
    try:
        branch = subprocess.check_output(["git", "-C", path, "rev-parse", "--abbrev-ref", "HEAD"], text=True).strip()
        sha = subprocess.check_output(["git", "-C", path, "rev-parse", "--short", "HEAD"], text=True).strip()
        return branch, sha
    except: return None, None

def audit():
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    with open(os.path.join(root, "manifest.json"), 'r') as f:
        cfg = json.load(f)

    target = cfg.get("target_branch", "scarthgap")
    bb_target = "2.8"
    all_ok = True

    print(f"\n[ SYMON OS AUDIT ]\n" + "-"*65)
    sources_path = os.path.join(root, "sources")
    for d in sorted(os.listdir(sources_path)):
        p = os.path.join(sources_path, d)
        if not os.path.isdir(p): continue
        branch, sha = get_git_info(p)

        expected = bb_target if "bitbake" in d else target
        status = "✓ OK" if branch == expected else "❌ MISMATCH"
        if "❌" in status: all_ok = False

        label = branch if branch != "HEAD" else sha
        print(f"{d:<30} | {label:<15} | {status}")
    return all_ok

if __name__ == "__main__":
    sys.exit(0 if audit() else 1)
