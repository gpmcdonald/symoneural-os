SyMoNeuRaL is a specialized Yocto Project distribution optimized for AI/ML workloads, NVIDIA GPU acceleration, and embedded neural processing. It follows a Poky-aligned "flat-root" architecture for maximum modularity.

## ⚡ The Synapse Portal

The `synapse` portal is the intelligent management tool for this repository. It handles submodule synchronization, environment isolation, and hardware-specific initializations.

### 1. Initial Setup
Run the script once from the repository root. You can optionally install it to your system path:

```bash
# Run directly
./scripts/synapse.sh

# Optional: Install to ~/.local/bin for global access
./scripts/synapse.sh --install
2. Launching the EnvironmentOnce initialized, simply run the portal and select your target:Bashsynapse
🏗 Supported EnvironmentsTargetDescriptionOptimizationsHeadless BaseMinimal CLI imageLow-latency embedded tasksNeural-GUIFull Desktop EnvironmentNVIDIA RTX 5070 Ti / CUDA 12.xReferenceOE-Core Clean RoomUpstream testing & debugging📂 Repository Hierarchymeta-symoneural/: Primary OS Policy and Distro configurations.meta-symoneural-bsp/: Board Support Package logic (Alienware R11, RPi4, Generic X86).openembedded-core/: The upstream build engine (Submodule).meta-poky/: Yocto Project reference metadata (Submodule).bitbake/: Task execution engine (Submodule).🛠 MaintenanceSubmodule SynchronizationIf you skip the synapse portal, manually sync the dependencies:Bashgit submodule update --init --recursive
Factory ResetTo wipe all build artifacts and start with a clean state:Bash./scripts/synapse.sh
# Select Option 4 (Factory Reset)
Maintained by: Garrett Parker McdonaldStatus: Scarthgap Release 1.0 (Active Development)
