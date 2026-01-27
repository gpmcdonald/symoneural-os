# SyMoNeuRaL OS (Scarthgap Edition)

A high-performance Linux distribution framework targeting x86_64 workstations and Zynq-7000 embedded systems.

## 🏗 Build Architecture

### Environment Initialization

**SyMoNeuRaL Standard Build**
Initializes with custom SyMoNeuRaL metadata, machine logic, and distro policy.
```bash
source configure-symoneural symoneural-build
bitbake symoneural-image-tiny
```

**OpenEmbedded Reference Build**
Initializes a clean-room environment using upstream OE-Core samples for verification. This operates exactly as a standalone OE-Core clone.
```bash
TEMPLATECONF="meta/conf/templates/default" source configure-oe-ref oe-core-ref-build
bitbake core-image-minimal
```

## 📂 Repository Structure
- `meta-symoneural/`: Custom policy, hardware support, and core recipes.
- `openembedded-core/`: Upstream build engine (Submodule).
- `bitbake/`: Task execution engine (Submodule).

## 🛠 Prerequisites
Before first use, synchronize the submodules:
```bash
git submodule update --init --recursive
```
