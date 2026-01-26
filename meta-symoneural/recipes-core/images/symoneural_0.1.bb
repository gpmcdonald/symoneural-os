SUMMARY = "SyMoNeuRaL OS Standalone Image"
DESCRIPTION = "A fully independent image recipe for SyMoNeuRaL OS."
LICENSE = "MIT"

# 1. Inherit the core engine instead of requiring a specific recipe
inherit core-image

# ------------------------------------------------------------
# 2. Distro Branding & Versioning
# ------------------------------------------------------------
DISTRO_NAME = "SyMoNeuRaL"
DISTRO_VERSION = "1.0-scarthgap"

# ------------------------------------------------------------
# 3. Image Features
# ------------------------------------------------------------
# We explicitly add 'packagegroup-core-boot' via IMAGE_INSTALL
# to ensure the system actually boots.
IMAGE_FEATURES += " \
    splash \
    ssh-server-dropbear \
    ${@bb.utils.contains('DISTRO_FEATURES', 'api-dev', 'dev-pkgs', '', d)} \
"

# ------------------------------------------------------------
# 4. Package Selection
# ------------------------------------------------------------
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

# ------------------------------------------------------------
# 5. Image Adjustments
# ------------------------------------------------------------
IMAGE_LINGUAS = "en-us"
IMAGE_OVERHEAD_FACTOR ?= "1.3"
IMAGE_ROOTFS_EXTRA_SPACE = "51200"
