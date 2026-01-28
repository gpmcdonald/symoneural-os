import subprocess
import os
import sys

def get_git_info(path):
    try:
        branch = subprocess.check_output(["git", "-C", path, "rev-parse", "--abbrev-ref", "HEAD"], text=True).strip()
        sha = subprocess.check_output(["git", "-C", path, "rev-parse", "HEAD"], text=True).strip()
        return branch, sha
    except Exception:
        return None, None

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
    # Note: Using sources/openembedded-core as the standard reference
    sources_path = os.path.join(root, "sources/openembedded-core")
    meta_path = os.path.join(root, "meta-symoneural")

    oe_branch, oe_sha = get_git_info(sources_path)
    meta_branch, meta_sha = get_git_info(meta_path)
    compat_list = get_layer_compat(meta_path)

    print(f"\n[ SYNERGY AUDIT ]")
    print(f"➜ OE-CORE:  {oe_branch} ({oe_sha[:10] if oe_sha else 'N/A'})")
    print(f"➜ META-SYM: {meta_branch} (Supports: {', '.join(compat_list)})")

    if oe_branch and oe_branch not in compat_list:
        print(f"\n❌ VERSION MISMATCH!")
        print(f"OE-CORE is '{oe_branch}', but your layer expects: {compat_list}")
        print("-" * 40)
        print("1) Sync SOURCES to WORK")
        print("2) Sync WORK to SOURCES")
        print("3) Force build anyway")
        print("4) Abort")

        choice = input("\nSelection: ")
        if choice == "1":
            target = compat_list[0]
            subprocess.run(["git", "-C", sources_path, "checkout", target], check=True)
        elif choice == "2":
            subprocess.run(["git", "-C", meta_path, "checkout", oe_branch], check=True)
        elif choice == "4":
            sys.exit(1)
    else:
        print("✓ Compatibility Verified.")

if __name__ == "__main__":
    main()
