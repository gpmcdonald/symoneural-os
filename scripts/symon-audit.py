#!/usr/bin/env python3
import os, subprocess, sys, json, shutil

# Attempt to load Gemini SDK for AI advice
try:
    from google import genai
except ImportError:
    genai = None

def check_host_sanity():
    if sys.version_info < (3, 8):
        print("❌ Error: Python 3.8+ is required.")
        return False
    _, _, free = shutil.disk_usage("/")
    if free < 50 * 1024**3:
        print("⚠️  Warning: Low disk space (< 50GB).")
    return True

def get_git_info(path):
    try:
        branch = subprocess.check_output(["git", "-C", path, "rev-parse", "--abbrev-ref", "HEAD"], text=True).strip()
        sha = subprocess.check_output(["git", "-C", path, "rev-parse", "--short", "HEAD"], text=True).strip()
        return branch, sha
    except: return None, None

def audit():
    if not check_host_sanity(): return False
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    with open(os.path.join(root, "manifest.json"), 'r') as f:
        cfg = json.load(f)

    target = cfg.get("target_branch", "scarthgap")
    bb_target = "2.8" # Mandatory Bitbake version for Scarthgap
    all_ok = True

    print(f"\n[ SYMON OS AUDIT ]\n" + "-"*65)
    sources_path = os.path.join(root, "sources")
    if not os.path.exists(sources_path):
        print("❌ Error: 'sources/' directory missing. Run portal to sync submodules.")
        return False

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
