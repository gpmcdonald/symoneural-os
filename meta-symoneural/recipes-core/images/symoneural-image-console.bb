SUMMARY = "SyMoNeuRaL Console Image"
DESCRIPTION = "A basic console-only image that fully supports the target hardware."
LICENSE = "MIT"

# Use core-image-base as the foundation (includes basic drivers/wifi/etc)
require recipes-core/images/core-image-base.bb

# Only add universal utility tools for now
IMAGE_INSTALL:append = " \
    openssh \
    htop \
    bc \
    rsync \
"

# Basic developer features
IMAGE_FEATURES += "debug-tweaks ssh-server-openssh"
