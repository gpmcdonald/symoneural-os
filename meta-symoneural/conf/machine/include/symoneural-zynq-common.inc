# Common SyMoNeuRaL settings for Zynq-7000 series
MACHINE_FEATURES += "usbhost eth vfat ext2"
SERIAL_CONSOLES = "115200;ttyPS0"

# Authority for branding
SYMON_SPLASH_FILE = "miner_splash.png"

# Ensure the kernel and bootloader match our SyMoNeuRaL policy
PREFERRED_PROVIDER_virtual/kernel = "linux-xlnx"
PREFERRED_VERSION_linux-xlnx = "6.6%"