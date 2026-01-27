SyMoNeuRaL OS (Scarthgap Edition)SyMoNeuRaL is a specialized Yocto Project distribution optimized for AI/ML workloads, NVIDIA GPU acceleration (RTX 5070 Ti), and embedded neural processing. It follows a Poky-aligned "flat-root" architecture for maximum modularity.🏗 Build ArchitectureThe repository supports two distinct build pathways:1. SyMoNeuRaL Environment (Custom OS)Initializes with custom branding, policies, and hardware optimizations.Targets: symoneural-image-base or symoneural-image-guiMachine: alienware-r11 (Default)2. OpenEmbedded Reference Build (Clean Room)Initializes a clean, upstream environment using only core metadata for verification.Target: core-image-minimal⚡ The Synapse PortalThe synapse portal is the intelligent management tool for this repository. It handles submodule synchronization, environment isolation, and hardware-specific initializations.UsageBash# Run directly from repo
./scripts/synapse.sh

# Optional: Install globally to ~/.local/bin
./scripts/synapse.sh --install

# Launch from anywhere
synapse

# Uninstall global command
synapse --remove
🏗 Supported EnvironmentsTargetDescriptionOptimizationsHeadless BaseMinimal CLI imageLow-latency embedded tasksNeural-GUIFull Desktop EnvironmentNVIDIA RTX 5070 Ti / CUDA 12.xReferenceOE-Core Clean RoomUpstream testing & debugging📂 Repository Hierarchymeta-symoneural/: Primary OS Policy & Distro layer (Priority 7).meta-symoneural-bsp/: Hardware Abstraction layer (Priority 6).meta-poky/: Yocto Project reference metadata (Submodule).openembedded-core/: Upstream build engine (Submodule).bitbake/: Task execution engine (Submodule).scripts/: Maintenance and alignment utilities.🛠 Setup & MaintenanceSynchronize submodules (Synapse does this automatically on launch):Bashgit submodule update --init --recursive
To wipe build artifacts:Bash./scripts/synapse.sh
# Select Option 4 (Factory Reset)
Maintained by: Garrett Parker McdonaldStatus: Scarthgap Release 1.0 (Active Development)
