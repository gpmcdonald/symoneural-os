# SyMoNeuRaL OS (Scarthgap Edition)

A professional OpenEmbedded-based framework following the Poky flat-root architecture. This repository separates OS Policy from Hardware BSP and provides two distinct build pathways.

## 🏗 Build Architecture

### 1. SyMoNeuRaL Environment (Custom OS)
Initializes using custom branding, policies, and hardware optimizations for the **RTX 5070 Ti**.
```bash
TEMPLATECONF="meta-symoneural/conf/templates/default" source configure-symoneural symoneural-build
bitbake symoneural-image-base
```

### 2. OpenEmbedded Reference Build (Clean Room)
Initializes a clean, upstream environment using only core metadata.
```bash
TEMPLATECONF="openembedded-core/meta/conf/templates/default" source configure-oe-ref oe-core-ref-build
bitbake core-image-minimal
```

## 📂 Repository Structure
- `meta-symoneural/`: OS Policy & Distro layer (Priority 7).
- `meta-symoneural-bsp/`: Hardware Abstraction layer (Priority 6).
- `meta-poky/`: Yocto Project reference distribution (Submodule).
- `openembedded-core/`: Upstream build engine (Submodule).
- `bitbake/`: Task execution engine (Submodule).
- `scripts/`: Maintenance and alignment utilities.

## 🛠 Setup
Synchronize submodules before first use:
```bash
git submodule update --init --recursive
```
