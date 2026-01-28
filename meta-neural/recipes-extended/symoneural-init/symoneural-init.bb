SUMMARY = "SyMoNeuRaL Extended Init Services"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

SRC_URI = " \
    file://symoneural-setup.sh \
    file://symoneural-init.service \
"

S = "${WORKDIR}"

SYSTEMD_SERVICE:${PN} = "symoneural-init.service"
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
    # Install the script to /usr/bin
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/symoneural-setup.sh ${D}${bindir}/

    # Install the service file to systemd directory
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/symoneural-init.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += "${systemd_system_unitdir}/symoneural-init.service"
