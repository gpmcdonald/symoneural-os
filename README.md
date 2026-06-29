# SyMoNeuRaL OS (Scarthgap Migration)

A Yocto-based system orchestrator project designed for high-performance computing and embedded FPGA applications.  
Currently migrating to the **Scarthgap LTS** release (Yocto 5.0.x).

## 🚀 Getting Started

Follow the steps below to set up and begin using SyMoNeuRaL OS.

### 1. Initialize the Workspace

Use the included synchronization tool to initialize submodules (BitBake, OE-Core), verify project anchors, and configure execution permissions:

```bash
./symon-sync.sh
```

### 2. Enter the Build Environment

The build portal ensures isolated and clean configuration directories. Source the portal script to access the appropriate environment:

```bash
source ./scripts/symon-portal.sh
```

You can choose between:
- **Custom SyMoNeuRaL Environment**: Lands in `symon-build/`
- **Pure Upstream Poky Environment**: Lands in `poky-build/`

---

## ⚡ Phase 2: High-Performance Storage (AIStore)

To avoid disk I/O bottlenecks and FUSE-backed storage overhead, model artifacts must live on the direct NVMe partition mounted at `/mnt/symon_store` from `/dev/nvme0n1p2`.

### AIStore prerequisites

- `/dev/nvme0n1p2` is already provisioned by the operator and mounted at `/mnt/symon_store`
- AIStore is checked out at `$GOPATH/src/github.com/NVIDIA/aistore`
- `go`, `make`, and `axel` are installed

### Validate the NVMe-backed store

Use the repository helper before deploying or downloading models:

```bash
./scripts/symon-aistore.sh check
```

### Initialize AIStore

The helper validates the mount, configures AIStore to use `/mnt/symon_store` as a preconfigured mountpath, deploys a minimal local cluster, and verifies cluster health:

```bash
./scripts/symon-aistore.sh deploy
```

This wraps the Phase 2 workflow around the standard AIStore local deployment flow:

```bash
cd "$GOPATH/src/github.com/NVIDIA/aistore"
make kill clean cli aisloader deploy <<< $'1\n1\n0'
ais show cluster
```

### Optimal model downloading strategy

Do not stream large model downloads directly into a FUSE-backed mount such as an Rclone or Google Drive mount. Stage them locally first with `axel`, then move them onto the NVMe-backed store. This avoids FUSE overhead, degraded throughput, and partially written artifacts from interrupted streaming downloads:

```bash
./scripts/symon-aistore.sh download <url> [output-name]
```

The helper downloads into `/tmp/symoneural-aistore-downloads` first and then moves the finished artifact into `/mnt/symon_store/models`.

---

## 📂 Project Structure

The repository is organized into the following key components:

- **`meta-symon/`**:  
  Custom system orchestrator layer and Scarthgap migration templates.

- **`scripts/`**:  
  Tools for audit (`symon-audit.py`), build management (`symon-portal.sh`), and AIStore/NVMe workflows (`symon-aistore.sh`).

- **`manifest.json`**:  
  The project's "Source of Truth" for version tracking and branch alignment.

- **`symon-sync.sh`**:  
  Workspace synchronization tool for submodule health and lock-file cleanup.

- **`symon-init-build-env`**:  
  Core environment wrapper for standardized paths.

---

## 🤖 CUSTOM_LOCAL_AI WORKFLOW

> **Target Platform:** Debian 13 (Trixie) · CUDA · NVIDIA GeForce RTX 5070 Ti (GB203)

### Prerequisites

```bash
sudo apt-get install g++ freeglut3-dev build-essential libx11-dev \
    libxmu-dev libxi-dev libglu1-mesa-dev libfreeimage-dev libglfw3-dev
```

---

### 1. NVIDIA CUDA Driver Setup

Full guide: https://docs.nvidia.com/cuda/archive/12.8.0/cuda-installation-guide-linux

#### a. Verify GPU

```bash
lspci | grep -i nvidia
# Compare result to https://developer.nvidia.com/cuda/gpus
# Expected: 01:00.0 VGA compatible controller: NVIDIA Corporation GB203 [GeForce RTX 5070 Ti]
```

#### b. Verify OS

```bash
uname -m && cat /etc/*release
# Expected: x86_64 / Debian GNU/Linux 13 (trixie)
```

#### c. Verify GCC

```bash
gcc --version
```

#### d. Choose & Download Installer

Download from https://developer.nvidia.com/cuda-downloads

**MD5 Checksums for CUDA 12.6.2 (560.35.03):**

| File | MD5 |
|------|-----|
| `cuda-repo-debian11-12-6-local_12.6.2-560.35.03-1_amd64.deb` | `7b032f0534c2193de8ff25af1e5ce468` |
| `cuda-repo-debian12-12-6-local_12.6.2-560.35.03-1_amd64.deb` | `298d2332d4a2379cc19865db45419835` |
| `cuda_12.6.2_560.35.03_linux.run` | `dcba85e2d49d7e6d93d8626f708276a4` |
| `cuda-repo-ubuntu2404-12-6-local_12.6.2-560.35.03-1_amd64.deb` | `89a0de97a30e1832f98e99a867926228` |
| `cuda-repo-ubuntu2204-12-6-local_12.6.2-560.35.03-1_amd64.deb` | `081bce9e80ff0609b54c55dbaaea778d` |
| `cuda-repo-rhel9-12-6-local-12.6.2_560.35.03-1.x86_64.rpm` | `3b63053ff5905e70ed5247fe01fe1261` |
| `cuda-repo-wsl-ubuntu-12-6-local_12.6.2-1_amd64.deb` | `e9bac16ee5f45e343f625068445da3b1` |

#### e. Verify the Download

```bash
md5sum <downloaded-file>
```

#### f. Install CUDA Keyring

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
```

#### g. Install CUDA SDK

```bash
sudo apt-get install cuda-toolkit
sudo reboot
```

#### h. Post-Installation Environment Setup

```bash
# Add CUDA binaries to PATH
export PATH=/usr/local/cuda-12.6/bin${PATH:+:${PATH}}

# For 64-bit systems (LD_LIBRARY_PATH):
export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# For 32-bit systems (LD_LIBRARY_PATH):
export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

#### i. Test the Installation

- Clone and run samples: https://github.com/nvidia/cuda-samples
- Verify `deviceQuery` output: https://docs.nvidia.com/cuda/archive/12.8.0/cuda-installation-guide-linux/_images/valid-results-from-sample-cuda-devicequery-program.png
- Advanced setup: https://docs.nvidia.com/cuda/archive/12.8.0/cuda-installation-guide-linux/#advanced-setup

---

### 2. NVIDIA AIStore Setup

Full guide: https://docs.nvidia.com/aistore/getting_started

#### a. Disk Setup

Before deploying AIStore, identify and configure dedicated storage:

1. **Identify the target disk** — choose the NVMe or HDD that will back the object store
2. **Determine disk size** — ensure sufficient capacity for model artifacts and datasets
3. **Partition the disk** — create a dedicated partition (e.g., `/dev/nvme0n1p2`)

#### b. Mount Configuration

Register the partition in `/etc/fstab` for persistent mounting, or create a systemd `.service` unit for lifecycle-managed mounting.

#### c. Clone & Deploy AIStore

```bash
cd $GOPATH/src/github.com/NVIDIA
git clone https://github.com/NVIDIA/aistore
cd aistore

# Build CLI and aisloader (bench), then deploy a minimal cluster
make kill clean cli aisloader deploy <<< $'1\n1'

# Verify the cluster is running
ais show cluster
```

#### d. Learn the CLI

Full CLI reference: https://docs.nvidia.com/aistore/cli

---

### 3. llama.cpp Setup

```bash
git clone --depth=1 https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -Bbuild
# Install any generated .deb packages
sudo dpkg -i *.deb
```

---

### Getting Started

```bash
# Confirm AIStore cluster health
ais show cluster
```

**Useful Resources:**

- 🤗 Hugging Face Models: https://huggingface.co/models
- NVIDIA AIStore Docs: https://docs.nvidia.com/aistore/

---

## 🛠 Status & Roadmap

The project is actively being developed with the following key milestones:

- [ ] Align submodules to Scarthgap (v2.8)
- [ ] Finalize environment initialization wrapper and portal
- [ ] Extract Antminer FPGA bitstreams
- [ ] Migrate `meta-neural` custom recipes for Scarthgap compatibility
- [ ] Verify initial builds on Alienware R11

---

## 📖 License

*(Insert your licensing policy here or leave this section if there’s no license yet.)*

---

### Contributions & Support

Contributions are welcomed! Please submit your ideas, issues, or improvements via pull requests. For support, open an issue, and we’ll get back to you.

---

Let me know if this version meets your expectations or if you'd like to add anything further!