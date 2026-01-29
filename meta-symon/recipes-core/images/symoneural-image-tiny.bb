SUMMARY = "SyMoNeuRaL Tiny OS Image"
DESCRIPTION = "A minimalist base for SyMoNeuRaL embedded targets."
LICENSE = "MIT"

# Use the OE-Core standard minimal image as the foundation
inherit classes-recipe/core-image

# Core requirements for the 'Tiny' flavor
IMAGE_INSTALL += " \
    packagegroup-core-boot \
    symoneural-init \
    os-release \
"

# Keep it lean
IMAGE_FEATURES += "debug-tweaks"
IMAGE_ROOTFS_SIZE ?= "8192"
