SUMMARY = "SyMoNeuRaL OS Standalone Image"
DESCRIPTION = "A fully independent image recipe for SyMoNeuRaL OS."
LICENSE = "MIT"

inherit symon-core-image

IMAGE_FEATURES += " \
    splash \
    ssh-server-dropbear \
    ${@bb.utils.contains('DISTRO_FEATURES', 'api-dev', 'dev-pkgs', '', d)} \
"

SYMONEURAL_BOOT = "packagegroup-core-boot"

SYMONEURAL_CORE = " \
    base-files \
    psplash \
"

SYMONEURAL_TOOLS = " \
    bc \
    strace \
"

SYMONEURAL_EXTRA_INSTALL ?= ""

IMAGE_INSTALL = " \
    ${SYMONEURAL_BOOT} \
    ${SYMONEURAL_CORE} \
    ${SYMONEURAL_TOOLS} \
    ${SYMONEURAL_EXTRA_INSTALL} \
"

IMAGE_LINGUAS = "en-us"
IMAGE_OVERHEAD_FACTOR ?= "1.3"
IMAGE_ROOTFS_EXTRA_SPACE = "51200"
