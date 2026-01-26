# SyMoNeuRaL OS (Scarthgap Edition)

Integrated build environment for high-performance x86 workstations and Zynq-based embedded miners.

## Project Layout
- `meta-symoneural/`: Custom metadata layer (Recipes, Machines, Distros).
- `poky/`: Core Yocto Project build system.
- `build/`: Local build output (not tracked).

## Building
1. `source poky/oe-init-build-env build`
2. Set your environment:
   - Workstation: `export MACHINE=symon-x86-workstation` / `export DISTRO=symon-bleeding`
   - Miner: `export MACHINE=symoneural-miner-zynq` / `export DISTRO=symonos`
3. `bitbake symoneural-image-tiny`
