# SyMoNeuRaL OS (Scarthgap Edition)

A flexible OpenEmbedded-based framework designed for custom Linux development. SyMoNeuRaL follows a Poky-style flat-root architecture, providing a complete ecosystem for distribution and hardware development.

## 🏗 Build Architecture

SyMoNeuRaL is structured as a modular framework. You can choose to use the SyMoNeuRaL policy or revert to a standard Reference Build at any time.

### Environment Initialization

**SyMoNeuRaL Environment**
Initializes with custom metadata, machine logic, and distro policy (Standard SyMoNeuRaL workflow).
```bash
source configure-symoneural symoneural-build
bitbake symoneural-image-tiny
```

**OpenEmbedded Reference Build**
Initializes a clean-room environment using upstream OE-Core samples. This operates exactly as a standalone OE-Core/Poky clone.
```bash
TEMPLATECONF="meta/conf/templates/default" source configure-oe-ref oe-core-ref-build
bitbake core-image-minimal
```

## 📂 Repository Structure
- `meta-symoneural/`: Custom metadata layer (Recipes, Machines, Distros).
- `meta-poky/`: The official Yocto Project reference distribution layer.
- `openembedded-core/`: Upstream build engine (Submodule).
- `bitbake/`: Task execution engine (Submodule).
- `meta-*`: Core metadata layers (meta, meta-skeleton, meta-selftest).
- `scripts/`: Utility and maintenance scripts.

## 🛠 Prerequisites
Synchronize submodules to populate the core engines:
```bash
git submodule update --init --recursive
```
