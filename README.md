#  󱁫 SyMoNeuRaL OS (Scarthgap Migration)

A Yocto-based system orchestrator project designed for high-performance computing and embedded FPGA applications. This project is currently undergoing a migration to the **Scarthgap LTS** release.

## 🚀 Getting Started

### 1. Initialize the Workspace
Run the sync tool to initialize submodules (BitBake, OE-Core), verify project anchors, and set proper execution permissions:
```bash
./symon-sync.sh

### 2. Enter the Build Environment
The portal manages build directory isolation to prevent configuration pollution. You must source the portal to correctly land in the build directory:

source ./scripts/symon-portal.sh

* Option 1: Custom SyMoNeuRaL environment (lands in symon-build/)
* Option 2: Pure Upstream Poky environment (lands in poky-buil

Project Structure

Directory/File
	Description
	sources/
	Submodules for Yocto engines (BitBake and OE-Core).
	meta-symon/
	Custom system orchestrator layer and Scarthgap migration templates.
	scripts/
	Audit engine (symon-audit.py) and Management Portal (symon-portal.sh).
	manifest.json
	Project "Source of Truth" for version tracking and branch alignment.
	symon-sync.sh
	Maintenance tool for submodule health and lock-file cleanup.
	symon-init-build-env
	Core environment wrapper for standardized pathing.
________________
🛠 Status & Roadmap
* [x] Align submodules to Scarthgap (v2.8)
* [x] Finalize environment initialization wrapper and portal
* [ ] Extract Antminer FPGA bitstreams
* [ ] Migrate meta-neural custom recipes for Scarthgap compatibility
* [ ] Initial build verification on Alienware R11
