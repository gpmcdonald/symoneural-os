# SyMoNeuRaL OS

**SyMoNeuRaL** is a custom embedded Linux distribution built on the Yocto Project (OpenEmbedded).

## Project Structure

* **meta-symoneural/**: Custom metadata, recipes, and machine configurations.
* **scripts-symoneural/**: Management and deployment utilities.
* **contrib-symoneural/**: Experimental tools and extensions.

## Getting Started

1. Initialize the build environment:
   `source oe-init-build-env build`

2. Build the target image:
   `bitbake symoneural`

## Target Hardware
* Alienware R11 (NVIDIA RTX 5070 Ti)
* Raspberry Pi 4 (64-bit)
* Generic x86-64 (UEFI)
