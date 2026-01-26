SUMMARY = "SyMoNeuRaL Tiny Miner OS"
DESCRIPTION = "Standalone Miner Image for Xilinx Zynq Hardware"
LICENSE = "MIT"

# Pull in core image logic
inherit core-image

# IMAGE-LEVEL AUTHORITY: Define exactly what goes in this build
IMAGE_INSTALL += " \
    packagegroup-core-boot \
    symoneural-init \
    kernel-modules \
    u-boot-zynq-uenv \
    openssh \
    htop \
    bc \
"

# Set Image features here instead of local.conf
IMAGE_FEATURES += "ssh-server-openssh debug-tweaks"
IMAGE_ROOTFS_SIZE ?= "8192"

# Ensure this image only builds for the intended hardware/distro if desired
# COMPATIBLE_MACHINE = "symoneural-miner-zynq"
