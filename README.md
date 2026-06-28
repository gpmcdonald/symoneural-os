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

- `/dev/nvme0n1p2` exists and is mounted at `/mnt/symon_store`
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

Do not stream large model downloads directly into a FUSE or Rclone mount. Stage them locally first with `axel`, then move them onto the NVMe-backed store:

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