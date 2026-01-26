# SymoNeuRaL Emulation

You can test SymoNeuRaL builds using QEMU without needing physical hardware.
This is useful for testing UI changes or boot scripts before deploying to the Alienware R11.

## Supported Emulation Targets

* **qemux86-64**: Simulates a generic 64-bit PC. Best for testing the "Generic x86" image.
* **qemuarm64**: Simulates a generic 64-bit ARM board. Best for testing logic intended for the Raspberry Pi 4.

## How to Run

1. **Build the image:**
   ```bash
   MACHINE=qemux86-64 bitbake symoneural
   ```

2. **Run the emulator:**
   ```bash
   runqemu qemux86-64
   ```
