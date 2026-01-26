SUMMARY = "SyMoNeuRaL Tiny Miner Image"
LICENSE = "MIT"
inherit core-image
IMAGE_INSTALL += "packagegroup-core-boot symoneural-init u-boot-zynq-uenv kernel-modules openssh htop bc"
IMAGE_FEATURES = "debug-tweaks ssh-server-openssh"
IMAGE_ROOTFS_SIZE ?= "8192"
