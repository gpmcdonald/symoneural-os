# SyMoNeuRaL OS (Scarthgap Edition)

A flexible OpenEmbedded-based framework designed for custom Linux development. SyMoNeuRaL follows a Poky-style flat-root architecture, providing a complete ecosystem for distribution and hardware development.

## 🏗 Build Architecture

### Environment Initialization

**SyMoNeuRaL Environment**
Initializes with custom metadata, machine logic, and distro policy.
```bash
source configure-symoneural symoneural-build
bitbake symoneural-image-tiny
```

**OpenEmbedded Reference Build**
Initializes a clean-room environment using upstream OE-Core samples.
```bash
TEMPLATECONF="meta/conf/templates/default" source configure-oe-ref oe-core-ref-build
bitbake core-image-minimal
```

## 📂 Repository Structure
- `meta-symoneural/`: Primary project metadata (Recipes, Machines, Distros).
- `meta-symoneural-bsp/`: Hardware abstraction layer (Machine configs & BSP).
- `meta-poky/`: The official Yocto Project reference distribution layer.
- `openembedded-core/`: Upstream build engine (Submodule).
- `bitbake/`: Task execution engine (Submodule).
- `meta/`: Standard OE-Core metadata.
- `meta-{skeleton,selftest}/`: Reference and testing metadata layers.
- `scripts/`: Utility and maintenance scripts.

## 🛠 Prerequisites
Synchronize submodules before initialization:
```bash
git submodule update --init --recursive
```
