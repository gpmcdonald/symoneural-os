# Ensure BitBake looks in this layer first for files
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Do NOT rely on file://motd lookup (poky override wins there)
# Instead, install our own explicitly-named MOTD
SRC_URI:append = " file://symoneural/motd file://symoneural/issue"

do_install:append () {
    install -m 0644 ${WORKDIR}/symoneural/motd ${D}${sysconfdir}/motd
    install -m 0644 ${WORKDIR}/symoneural/issue ${D}${sysconfdir}/issue
}
