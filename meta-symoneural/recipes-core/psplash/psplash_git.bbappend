# SyMoNeuRaL: Inject Custom Splash Screen if defined

python () {
    # Check if the variable is set in local.conf
    splash = d.getVar('SYMON_SPLASH_FILE')
    
    if splash:
        d.appendVar('DEPENDS', ' gdk-pixbuf-native-base-native')
        d.appendVar('SRC_URI', ' file://' + splash)
}
