# SyMoNeuRaL OS (Scarthgap Edition)

A professional OpenEmbedded-based framework following the Poky flat-root architecture.

# 🏗 Build Architecture

### 1. SyMoNeuRaL Environment (Custom OS)
Initializes using custom branding, policies, and hardware optimizations for the **RTX 5070 Ti**.
- **Initialize:** `synapse` (Select Option 1 or 2)
- **Target:** `bitbake symoneural-image-base`

### 2. OpenEmbedded Reference Build (Clean Room)
Initializes a clean, upstream environment using only core metadata.
- **Initialize:** `synapse` (Select Option 3)
- **Target:** `bitbake core-image-minimal`

## ⚡ The Synapse Portal

The `synapse` portal is the intelligent management tool for this repository. It handles submodule synchronization, environment isolation, and hardware-specific initializations.

### Usage
```bash
# Run directly
./scripts/synapse.sh

# Optional: Install to path
./scripts/synapse.sh --install

# Launch globally
synapse

# To remove global command
synapse --remove
```

## 📂 Repository Structure

* **meta-symoneural/**: OS Policy & Distro layer
* **meta-symoneural-bsp/**: Hardware Abstraction layer
* **meta-poky/**: Yocto Project reference distribution (Submodule)
* **openembedded-core/**: Upstream build engine (Submodule)
* **bitbake/**: Task execution engine (Submodule)
* **scripts/**: Maintenance and alignment utilities

## 🛠 Setup

Synchronize submodules before first use (Synapse does this automatically):
```bash
git submodule update --init --recursive
```

---
**Maintained by:** Garrett Parker Mcdonald
**Status:** Scarthgap Release 1.0 (Active Development)
