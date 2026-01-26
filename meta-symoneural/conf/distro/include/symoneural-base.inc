# Inherit sane defaults from OE-Core, not the Poky branding
require conf/distro/include/default-distrovars.inc
require conf/distro/include/default-setup-layers.inc

# SyMoNeuRaL Policy
DISTRO_FEATURES:append = " systemd pam multiarch"
DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit"
