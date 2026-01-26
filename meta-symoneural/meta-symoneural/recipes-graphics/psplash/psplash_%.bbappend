FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
DEPENDS += "gdk-pixbuf-native"
SRC_URI += "file://psplash-poky-img.png"
SPLASH_IMAGES = "file://psplash-poky-img.png;fallback=true"
