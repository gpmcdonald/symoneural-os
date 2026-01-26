# Add our local files directory to the search path
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add our custom branding files
SRC_URI += " \
    file://motd \
    file://issue \
"

# Install the files into the root filesystem
do_install:append () {
    install -m 0644 ${WORKDIR}/motd ${D}${sysconfdir}/motd
    install -m 0644 ${WORKDIR}/issue ${D}${sysconfdir}/issue
}
