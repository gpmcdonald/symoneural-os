# Debian 13 KDE Plasma Dev Setup Script

This repository provides an **interactive, safety-first bootstrap script**
for **Debian 13 (Trixie)**.

The script prepares a **development-ready system** while explicitly verifying
package availability, handling dependency issues gracefully, and avoiding
destructive assumptions.

---

## What a User Should Expect When Running `setup.sh`

### 1) Immediate Startup Behavior

- Script re-execs as root if needed
- User may be prompted **once** for sudo password
- No installs happen yet
- Structured output begins: `[*]`, `[OK]`, `[WARN]`, `[FAIL]`
- A log file is created under:

```
/var/log/symon_deb13_devready_YYYYMMDD-HHMMSS.log
```

Example output:
```
[*] Log file: /var/log/symon_deb13_devready_20260110-xxxxxx.log
[OK] Running as root.
```

---

### 2) Preflight APT Sanity

- Script runs:
  ```
  apt-get update
  ```
- This happens **once**, early
- Ensures `apt-cache show` works correctly
- No packages are installed yet

If networking is broken, **this is the first failure point**.

---

### 3) System Information Output

- `fastfetch` output if available
- Otherwise fallback info:
  - OS release
  - Kernel
  - GPU detection

This step is **informational only**.

---

### 4) Repair / Upgrade Prompts

User is prompted individually:

- Run `dpkg --configure -a`?
- Run `apt-get -f install`?
- Run `apt-get update + full-upgrade`?

Nothing runs without confirmation.  
User may answer **NO to all** and continue.

---

### 5) Package Manager Selection

- If `nala` is installed:
  - User is asked whether to use it
- If `nala` is not installed:
  - User is asked whether to install it

Exactly **one package manager** is used for the rest of the run.

---

### 6) APT Sources Enablement

The script safely enables:

- `contrib`
- `non-free`
- `non-free-firmware`

Behavior:
- No duplicate components
- Existing lines preserved
- Followed by `apt-get update`

---

### 7) User / Group Configuration

User selects which account to operate on.

Optional group additions:
- `sudo`
- `video`
- `render`
- `www-data`

Nothing is done silently.

---

### 8) Base Tooling Installation

- Packages verified via `apt-cache` first
- Replacements offered if missing
- Dependency simulation before install
- Failures logged but **do not abort** the script

---

### 9) Feature-by-Feature Interactive Installs

User is prompted individually for:

- Enable i386 multiarch
- Install explicit X11 stack
- Install KDE Plasma + SDDM
- Install Terminus console fonts
- Install VS Code
- Install Web/API stack
- Install Yocto / OpenEmbedded deps
- Install Xilinx deps
- Install OpenSSH (custom port)
- Install XRDP (custom port)
- Purge old NVIDIA stack
- Install Secure Boot / MOK tools
- Enable NVIDIA repo
- Install NVIDIA Open DKMS stack

Each choice immediately determines what runs next.

---

### 10) NVIDIA Secure Boot Behavior (If Selected)

- User is prompted to create a **MOK password**
- Script finishes normally
- User is instructed to reboot and enroll the key

A verification script is written to:
```
/root/dev_ready_post_reboot_check.sh
```

---

### 11) Final Summary

The script always prints a summary:
- Log file path
- Either:
  ```
  [OK] No failures recorded
  ```
  or
  ```
  List of non-fatal failures
  ```

Nothing is hidden.

---

### 12) Reboot Prompt

User is asked:
```
Reboot now (for MOK enrollment)?
```

- Yes → system reboots
- No  → script exits cleanly

---

## Bottom Line

- Script is **interactive**, not destructive
- Nothing is assumed
- Failures are logged, not fatal
- User always stays in control

---

## Key Goals

- Never assume a package exists
- Verify all packages via APT cache before installation
- Offer valid replacements when packages are missing
- Detect and repair broken dependencies safely
- Continue execution on non-fatal failures
- Log all actions and summarize failures at the end
- Keep all steps interactive and user-approved

---

## Included Capabilities

- Base developer tooling
- Explicit X11 stack
- KDE Plasma + SDDM (X11-based)
- Terminus console font configuration
- Optional i386 multiarch enablement
- Web/API stack (Node.js, PHP, Nginx, Redis, SQLite)
- Yocto / OpenEmbedded build dependencies
- Xilinx Vivado / Vitis / PetaLinux dependencies
- OpenSSH server (custom port support)
- XRDP remote desktop (custom port support)
- NVIDIA Open DKMS driver installation
- Secure Boot MOK enrollment workflow

---

## Usage

Make the script executable and run it as root:

```
chmod +x setup.sh
sudo ./setup.sh
```

Follow the interactive prompts. Nothing is installed without confirmation.

---

## Logs

All execution output is logged to:

```
/var/log/symon_deb13_devready_YYYYMMDD-HHMMSS.log
```

Failures (if any) are summarized at the end of the run.

---

## NVIDIA + Secure Boot Notes

If Secure Boot is enabled and NVIDIA Open DKMS drivers are installed:

1. Create a MOK password when prompted
2. Reboot when prompted
3. Enroll the MOK in firmware
4. Complete boot

After login, verify the system state by running:

```
sudo /root/dev_ready_post_reboot_check.sh
```

This script checks:
- Secure Boot state
- NVIDIA device nodes
- DKMS status
- Loaded kernel modules
- Relevant `dmesg` output

---

## Repository Layout

```
.
├── README.md    # Project documentation
├── setup.sh     # Main interactive bootstrap script
└── lib/         # Modular helpers
```

---

## Safety Guarantees

- No forced installs
- No silent dependency resolution
- No partial upgrades
- No hidden side effects
- Full transparency via logging

This script is designed for **repeatable, auditable system provisioning**.