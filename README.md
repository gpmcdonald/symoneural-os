# SyMoNeuRaL OS (Scarthgap Edition)

Integrated build environment for high-performance x86 workstations and Zynq-based embedded miners.

## 🚀 Getting Started

### 1. First-Time Setup (Crucial)
Before building, you must initialize the submodules to download the core engines:
```bash
git submodule update --init --recursive
```

Choose your environment path based on your requirements:

### Option A: SyMoNeuRaL OS (Recommended)
Use this for the custom SyMoNeuRaL identity, 6.12 kernel, and hardware-specific optimizations.
- **Config source:** Uses `meta-symoneural/conf/templates/default`
```bash
source configure-symoneural build
bitbake symoneural-image-tiny
```

### Option B: Vanilla OpenEmbedded (Standard)
Use this to get a 100% standard OpenEmbedded environment. This generates the full, annotated upstream `local.conf` with default `nodistro` settings.
- **Config source:** Uses `openembedded-core/meta/conf/templates/default`
```bash
TEMPLATECONF="openembedded-core/meta/conf/templates/default" source configure-vanilla-testing build-vanilla
bitbake core-image-minimal
```

## Project Layout
- `meta-symoneural/`: Custom metadata layer (Recipes, Machines, Distros).
- `openembedded-core/`: Core build system engine (Submodule).
- `bitbake/`: Build tool (Submodule).

## Hardware Support
- **Workstation:** symon-x86-workstation (NVIDIA RTX 5070 Ti)
- **Miner:** symoneural-miner-zynq (Xilinx Zynq-7010)
