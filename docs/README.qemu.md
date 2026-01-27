# SyMoNeuRaL QEMU Testing

Use these commands to test images on your Alienware R11 before flashing hardware.

## Running x86 Workstation
`runqemu symon-x86-workstation nographic`

## Running Zynq Miner (Emulated)
`runqemu symoneural-miner-zynq qemuparams="-m 1024"`

**Note:** GPU acceleration is not available in standard QEMU; use these for logic and init-script testing only.
