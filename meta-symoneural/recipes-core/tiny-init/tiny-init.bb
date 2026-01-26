SSUMMARY = "SyMoNeuRaL Tiny Init"
DESCRIPTION = "Minimal boot script for SyMoNeuRaL-tiny distributions."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://init"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}
    install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init
    # Link /init to our script so the kernel finds it
    ln -sf ${sysconfdir}/init ${D}/init
}

FILES:${PN} = "/init ${sysconfdir}/init"
