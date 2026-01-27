# SyMoNeuRaL OS (Scarthgap Edition)

A high-performance Linux distribution framework targeting x86_64 workstations and Zynq-7000 embedded systems.

## 🏗 Build Architecture

SyMoNeuRaL utilizes a flat OpenEmbedded-Core structure for maximum transparency and build performance.

### Environment Initialization

Choose the target profile:

**SyMoNeuRaL Standard Build**
```bash
source configure-symoneural build
bitbake symoneural-image-tiny
```

**Upstream Reference Build**
```bash
TEMPLATECONF="openembedded-core/meta/conf/templates/default" source configure-vanilla-testing build-vanilla
bitbake core-image-minimal
```

## 📂 Repository Structure
- `meta-symoneural/`: Custom policy, hardware support, and core recipes.
- `openembedded-core/`: Upstream build engine (locked to Scarthgap).
- `bitbake/`: Task execution engine.
- `meta-openembedded/`: Community maintained software layers.

## 🛠 Prerequisites
Ensure all submodules are synchronized before initialization:
```bash
git submodule update --init --recursive
```
