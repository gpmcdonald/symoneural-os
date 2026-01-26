FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# This tells Yocto to use YOUR image instead of the default Yocto logo
SPLASH_IMAGES:append = " file://psplash-symoneural-img.h;fallback=true"

# If you have a PNG, Yocto's script can convert it, but
# providing the .h header directly is the most reliable way.
