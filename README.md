# SyMoNeuRaL OS (Scarthgap Edition)

A flexible OpenEmbedded-based framework designed for custom Linux development. This environment provides the infrastructure to build, test, and deploy across diverse architectures without platform lock-in.

## 🏗 Build Architecture

SyMoNeuRaL is structured as a modular overlay. You can choose to use the SyMoNeuRaL policy or revert to standard OpenEmbedded-Core at any time.

### Environment Initialization

**SyMoNeuRaL Environment**
Initializes with custom metadata, machine logic, and distro policy. Use this for project-specific development.
```bash
source configure-symoneural symoneural-build
bitbake symoneural-image-tiny
```

**Standard OpenEmbedded Reference**
Initializes a clean-room environment using upstream OE-Core samples. This operates exactly as a standalone OE-Core clone, providing a completely untunneled, standard experience.
```bash
TEMPLATECONF="meta/conf/templates/default" source configure-oe-ref oe-core-ref-build
bitbake core-image-minimal
```

## 📂 Repository Structure
- `meta-symoneural/`: Custom metadata layer (Recipes, Machines, Distros).
- `openembedded-core/`: Upstream build engine (Submodule).
- `bitbake/`: Task execution engine (Submodule).

## 🛠 Prerequisites
Synchronize submodules to populate the core engines:
```bash
git submodule update --init --recursive
```
