# SyMoNeuRaL QEMU Base Configuration
# Common settings for all SyMoNeuRaL emulation targets

# Use the standard QEMU features from OE-Core
require conf/machine/include/qemu.inc

# SyMoNeuRaL specific overrides
EXTRA_IMAGEDEPENDS += "qemu-system-native qemu-helper-native"
MACHINE_FEATURES += "screen keyboard mouse alsa"

# Ensure we use the kernel version defined in our Distro configs
# but allow local overrides
PREFERRED_PROVIDER_virtual/kernel ?= "linux-yocto"
