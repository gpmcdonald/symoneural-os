# SymoNeuRaL OS

**SymoNeuRaL** is a custom embedded Linux distribution built on the Yocto Project (OpenEmbedded).

## 📂 Repository Structure

This repository follows the "Combo-Layer" pattern. It contains both the build engine and the custom metadata.

### 🔴 Your Code (Edit These)
* **`meta-symoneural/`**: The heart of the OS. Contains recipes, machine configs (Alienware/RPi), and distro policies.
* **`scripts-symoneural/`**: Custom management scripts (e.g., build wrappers, deployment tools).
* **`contrib-symoneural/`**: Experimental tools and one-off hacks.

### 🟡 Build Artifacts (Ignored by Git)
* **`build/`**: Generated output. Contains disk images, packages, and temporary compilation files.
* **`downloads/`**: Source code tarballs downloaded from the internet.

### 🔵 Vendor/Upstream (DO NOT EDIT)
* **`bitbake/`**: The build engine (Task scheduler).
* **`meta/`**: OpenEmbedded Core (Standard C library, GCC, core Linux tools).
* **`meta-openembedded/`**: Community layers (Networking, Python, UI).
* **`meta-clang/`**: LLVM compiler infrastructure.
* **`scripts/`**: Standard Yocto utilities (`runqemu`, `devtool`, `yocto-check-layer`).
* **`contrib/`**: Upstream community extras (Tab completion, vim syntax, etc.).

---

## 🚀 Quick Start

1. **Initialize Environment**
   ```bash
   source oe-init-build-env build
   ```

2. **Build the OS**
   ```bash
   bitbake symoneural
   ```

3. **Run Custom Scripts**
   Use your custom wrappers instead of manual commands:
   ```bash
   ./scripts-symoneural/build-all.sh
   ```

## Supported Hardware
* **Alienware R11** (NVIDIA RTX 5070 Ti)
* **Raspberry Pi 4** (64-bit)
* **Generic x86-64** (UEFI)

