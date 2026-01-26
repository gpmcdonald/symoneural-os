# NVIDIA Proprietary Driver Support (Bleeding Edge)
# Specifically for RTX 50-series (GDDR7) compatibility

# Add the required license flags for proprietary builds
LICENSE_FLAGS_ACCEPTED += "commercial_nvidia"

# Hardware-specific driver packages and utils
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += " \
    kernel-module-nvidia \
    nvidia-utils \
"

# Automated driver loading
KERNEL_MODULE_AUTOLOAD += "nvidia"

# Version authority for the latest driver stack
PREFERRED_VERSION_nvidia-open-kernel-modules = "590.%"