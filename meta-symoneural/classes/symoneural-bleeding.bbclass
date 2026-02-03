# This handler runs before the recipe is finalized to force AUTOREV
python symoneuralbleeding_version_handler () {
    bpn = d.getVar("BPN")
    # Clean up native/nativesdk prefixes so we match the real recipe name
    bpn = bpn.replace("-nativesdk", "").replace("nativesdk-", "")

    if bpn in (d.getVar("SYMONEURAL_AUTOREV_RECIPES") or "").split():
        d.setVar("SRCREV", "${AUTOREV}")
        
        # Update any sub-module revisions if they exist
        srcrev_format = d.getVar("SRCREV_FORMAT")
        if srcrev_format:
            for multi_scm in srcrev_format.split("_"):
                if multi_scm != "":
                    d.setVar("SRCREV_%s" % multi_scm, "${AUTOREV}")
        
        # Force the version string to indicate it's a git build
        if "+git" not in d.getVar("PV"):
            d.appendVar("PV", "+git")
}

addhandler symoneuralbleeding_version_handler
symoneuralbleeding_version_handler[eventmask] = "bb.event.RecipePreFinalise"