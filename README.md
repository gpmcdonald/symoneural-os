# SyMoNeuRaL OS (Scarthgap Edition)

Integrated build environment for high-performance x86 workstations and Zynq-based embedded miners.

## 🚀 Getting Started

After cloning, choose your environment path:

### Option A: SyMoNeuRaL OS (Recommended)
Use this for the full experience, including custom branding, the 6.12 kernel, and NVIDIA support.
```bash
source configure-symoneural build
bitbake symoneural-image-tiny
```

### Option B: Vanilla OpenEmbedded (Testing/Debug)
Use this to build a standard, unbranded image for debugging base layer issues.
```bash
TEMPLATECONF="" source configure-vanilla-testing build-vanilla
bitbake core-image-minimal
```

## Project Layout
- `meta-symoneural/`: Custom metadata layer (Recipes, Machines, Distros).
- `openembedded-core/`: Core build system engine.
- `bitbake/`: Build tool.

## Hardware Support
- **Workstation:** symon-x86-workstation (NVIDIA RTX 5070 Ti)
- **Miner:** symoneural-miner-zynq (Xilinx Zynq-7010)
