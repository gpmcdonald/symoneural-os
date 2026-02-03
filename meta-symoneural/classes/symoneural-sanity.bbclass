# meta-symoneural/classes/symoneural-sanity.bbclass

python symoneural_update_bblayersconf() {
    # 1. Get the current version from the user's bblayers.conf
    current_version = int(d.getVar('SYMONOS_BBLAYERS_CONF_VERSION') or -1)
    
    # 2. Get the required version from your distro config
    latest_version = int(d.getVar('REQUIRED_SYMONOS_BBLAYERS_CONF_VERSION') or -1)

    # 3. If they don't match, run update logic
    if current_version < latest_version:
        bb.note("SymonOS: Upgrading bblayers.conf from version %s to %s" % (current_version, latest_version))
        
        # ... (Insert logic here to rewrite the file, similar to poky-sanity) ...
        
        # 4. Update the version number in the file so we don't run this again
        # (Simplified logic - in reality you use regex to replace the text)
        bb.note("Configuration update complete.")
}

# Register this function to run during the configuration update phase
BBLAYERS_CONF_UPDATE_FUNCS += "conf/bblayers.conf:SYMONOS_BBLAYERS_CONF_VERSION:REQUIRED_SYMONOS_BBLAYERS_CONF_VERSION:symoneural_update_bblayersconf"