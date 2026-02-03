SUMMARY = "SyMoNeuRaL minimal image"
DESCRIPTION = "Minimal SyMoNeuRaL image with custom MOTD and user"
LICENSE = "MIT"

# Base image
require recipes-core/images/core-image-minimal.bb

# ------------------------------------------------------------
# Image features
# ------------------------------------------------------------
IMAGE_FEATURES:append = " \
    dev-pkgs \
    ssh-server-dropbear \
    splash \
"

# ------------------------------------------------------------
# Packages
# ------------------------------------------------------------
IMAGE_INSTALL:append = " \
    base-files \
    psplash \
    bc \
    strace \
"

