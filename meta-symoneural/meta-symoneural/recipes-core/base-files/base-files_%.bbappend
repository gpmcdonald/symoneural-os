FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://motd file://issue"

do_install:append () {
    install -m 0644 ${WORKDIR}/motd ${D}${sysconfdir}/motd
    install -m 0644 ${WORKDIR}/issue ${D}${sysconfdir}/issue
}
