FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# 1. Add tools only if a splash is requested
DEPENDS:append = " ${@bb.utils.contains('SYMON_SPLASH_FILE', '', '', 'gdk-pixbuf-native-base-native', d)}"

# 2. Only fetch the file if the variable is set
SRC_URI:append = " ${@bb.utils.contains('SYMON_SPLASH_FILE', '', '', 'file://${SYMON_SPLASH_FILE}', d)}"

# 3. Handle the conversion logic
python do_configure:prepend() {
    splash_file = d.getVar('SYMON_SPLASH_FILE')
    if splash_file:
        import subprocess
        workdir = d.getVar('WORKDIR')
        s = d.getVar('S')
        source_path = os.path.join(workdir, splash_file)

        if os.path.exists(source_path):
            bb.note("SyMoNeuRaL: Converting %s to header" % splash_file)
            # Run the conversion script provided by psplash
            script_path = os.path.join(s, 'make-image-header.sh')
            subprocess.run([script_path, source_path, 'POKY'], cwd=s, check=True)
        else:
            bb.fatal("SyMoNeuRaL: Splash file %s not found in WORKDIR" % splash_file)
}
