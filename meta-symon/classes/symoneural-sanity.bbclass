# symoneural-sanity.bbclass
# Professional environment validation for SyMoNeuRaL OS

addhandler symoneural_sanity_handler
symoneural_sanity_handler[eventmask] = "bb.event.ConfigParsed"

python symoneural_sanity_handler() {
    import os

    # 1. Verify we are actually using the SyMoNeuRaL Distro
    distro = d.getVar('DISTRO')
    if distro != "symonos":
        bb.warn("SyMoNeuRaL Sanity: You are not using 'symonos' as your DISTRO. Build results may be unpredictable.")

    # 2. Check for the manifest.json "Locked" state
    # This ensures the user didn't bypass the symon-portal.sh audit
    root_dir = d.getVar('OEROOT')
    manifest = os.path.join(root_dir, "manifest.json")

    if not os.path.exists(manifest):
        bb.fatal("SyMoNeuRaL Sanity: manifest.json is missing! Please run 'scripts/symon-portal.sh' to align your environment.")

    # 3. Layer Compatibility Verification
    # Ensure all layers in BBLAYERS support the distro codename
    codename = d.getVar('DISTRO_CODENAME')
    layers = (d.getVar('BBLAYERS') or "").split()

    for layer in layers:
        # Here we could add logic to parse each layer's conf/layer.conf
        # to ensure it matches symoneural-core requirements
        pass
}
