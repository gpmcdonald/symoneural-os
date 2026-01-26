SUMMARY = "SyMoNeuRaL Tiny Miner Image"
LICENSE = "MIT"
inherit core-image
IMAGE_INSTALL += "packagegroup-core-boot symoneural-init openssh htop bc"
IMAGE_FEATURES = "debug-tweaks"
IMAGE_ROOTFS_SIZE ?= "8192"
