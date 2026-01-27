# SyMoNeuRaL OS (Scarthgap)

SyMoNeuRaL is a specialized Yocto Project distribution optimized for AI/ML workloads, NVIDIA GPU acceleration, and embedded neural processing. It follows a Poky-aligned "flat-root" architecture for maximum modularity.

## 🔔 The Synapse Portal

The `synapse` portal is the intelligent management tool for this repository. It handles submodule synchronization, environment isolation, and hardware-specific initializations.

fi### 1. Initial Setup
Run the script once from the repository root. You can optionally install it to your system path:

```bash
# Run directly
./scripts/synapse.sh

# Optional: Install to ~/.local/bin for global access
./scripts/synapse.sh --install
```

### 2. Launching the Environment
Once initialized, simply run the portal and select your target:
```bash
synapse
```

### 3. Removal
To remove the global command and clean up your local bin:
``bash
synapse --remove
```

## 