SUMMARY = "SyMoNeuRaL OS Standalone Image"
LICENSE = "MIT"
inherit core-image

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    base-files \
    psplash \
    bc \
    strace \
"
IMAGE_FEATURES += "splash ssh-server-dropbear"
IMAGE_ROOTFS_EXTRA_SPACE = "51200"
