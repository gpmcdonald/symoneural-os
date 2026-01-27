# SyMoNeuRaL OS (Scarthgap Edition)

A flexible OpenEmbedded-based framework designed for custom Linux development. 

## 🏗 Build Architecture

### Environment Initialization

Choose the target profile:

**SyMoNeuRaL Environment**
Initializes with custom metadata, machine logic, and distro policy.
```bash
source configure-symoneural symoneural-build
bitbake symoneural-image-tiny
```

**Standard OpenEmbedded Reference**
Initializes a clean-room environment using upstream OE-Core samples. 
```bash
TEMPLATECONF="meta/conf/templates/default" source configure-oe-ref oe-core-ref-build
bitbake core-image-minimal
```

## 📂 Repository Structure
- `meta-symoneural/`: Custom metadata layer.
- `openembedded-core/`: Upstream build engine (Submodule).
- `bitbake/`: Task execution engine (Submodule).
- `scripts/`: Utility and maintenance scripts.

## 🛠 Prerequisites
Synchronize submodules before initialization:
```bash
git submodule update --init --recursive
```
