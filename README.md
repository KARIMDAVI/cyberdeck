# 📟 CYBERDECK v1 — Orange Pi 5B

<img width="1144" height="1609" alt="image" src="https://github.com/user-attachments/assets/ba6da383-3545-4b47-969a-0eb4a8f61ea7" />

<div align="center">

![Project Status](https://img.shields.io/badge/Status-In--Progress-orange?style=for-the-badge)
![OS](https://img.shields.io/badge/OS-Armbian%20Ubuntu%2024.04-blue?style=for-the-badge&logo=ubuntu&logoColor=white)
![Architecture](https://img.shields.io/badge/Arch-aarch64-green?style=for-the-badge)
![Compute](https://img.shields.io/badge/SoC-RK3588S-red?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=for-the-badge)

**A portable, hardened, field-ready ARM cyberdeck built on a single-source-of-truth design philosophy.**

</div>

---

## 🎯 Mission

Build a portable, secure, and maintainable cyberdeck that doesn't compromise:

| Goal | Implementation |
|:---|:---|
| **Boots reliably** | Stable Armbian base with optional Kali LXC toolsets |
| **Secure by default** | Hardened SSH, UFW firewall, key-based auth only |
| **Tactile & functional** | BBQ20 physical keyboard + portrait 5" touch display |
| **Maintainable** | Clean internal wiring + modular OpenSCAD chassis |

---

## 🛠 Hardware Specifications

| Component | Detail |
|:---|:---|
| **Compute Core** | Orange Pi 5B (Rockchip RK3588S · 8GB LPDDR5 · 64GB eMMC) |
| **Primary Display** | Waveshare 5" HDMI LCD (720×1280 native portrait) |
| **Tactile Input** | BBQ20 USB/BLE Keyboard (RP2040-based) |
| **Status Displays** | 2× 0.96" I2C OLED (SSD1306) |
| **Connectivity** | Wi-Fi 6 · BT 5.0 · Gigabit Ethernet · USB 3.0 · GPIO |
| **Chassis** | Custom OpenSCAD/PETG — 138 × 195 × 65 mm |

---

## 🔐 Software Architecture & Security

The system runs a **Dual-Layer OS Strategy** — maximum hardware stability paired with a full offensive security toolchain.

```
┌─────────────────────────────────────────────────┐
│  HOST OS — Armbian Ubuntu 24.04 (kernel 6.1.x)  │  ← Stability layer
│  ┌───────────────────────────────────────────┐  │
│  │  KALI LXC CONTAINER (unprivileged)        │  │  ← Tooling layer
│  │  kali-linux-default metapackages          │  │
│  └───────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

### Hardening Checklist

- [x] Password-based SSH login disabled
- [x] Root SSH login disabled
- [x] UFW firewall enabled (default deny incoming)
- [x] Key-based authentication enforced
- [x] Automated baseline via `opi5b_postinstall.sh`

> **Why LXC?** Running Kali inside an unprivileged LXC container prevents cross-distro dependency conflicts from destabilizing the host OS. The host stays clean; the tools stay available.

---

## 🔌 Internal Connectivity & Cable Routing

All cables route through a dedicated **28.9mm Y-axis cavity** between the screen and the board — the "Clean Interior" philosophy.

### Cable Map

| Signal | Route |
|:---|:---|
| **Video** | OPi HDMI OUT → Waveshare HDMI IN (FPC ribbon) |
| **Touch + Power** | OPi USB-C 3.0 → Waveshare USB-C (HID + power) |
| **Keyboard** | OPi USB-A 2.0 → BBQ20 USB-C (internal HID) |
| **Telemetry** | GPIO Header → Dual OLEDs (I2C1 + I2C4 buses) |

### External Port Access

```
RIGHT WALL  │  USB 3.0 (exposed) · Ethernet · Dual OLED windows
LEFT WALL   │  Power button · MIC hole
BOTTOM EDGE │  USB-C power input · 3.5mm audio
```

---

## 📂 Repository Structure

```text
.
├── scripts/                  # Automation and post-install hardening
│   └── opi5b_postinstall.sh
├── case/                     # OpenSCAD 3D design files
│   └── REVIEW-CASE.scad
├── BBQ20-USB-keyboard/       # Firmware and hardware for Q20 keyboard
├── Cyberdeck/                # PCB Gerber files and BOM
├── DESIGN_SPEC_v5.md         # Master geometric measurements (frozen)
└── PROJECT_STATUS.md         # ← Single source of truth
```

---

## 🚀 Getting Started

### 1. Host Preparation

Flash Armbian to MicroSD or eMMC, then run the post-install hardening script:

```bash
sudo ./scripts/opi5b_postinstall.sh
```

Verify before moving on:

```bash
sudo ufw status          # Should show: active, default deny incoming
ssh-keygen -l -f ~/.ssh/authorized_keys   # Confirm your key is enrolled
```

### 2. Kali LXC Setup *(Optional)*

Run offensive tools safely inside an unprivileged container:

```bash
# Install LXC on host
sudo apt install lxc lxc-templates

# Create Kali arm64 container
sudo lxc-create -t download -n kali-arm64

# Start and attach
sudo lxc-start -n kali-arm64
sudo lxc-attach -n kali-arm64

# Inside container — install default Kali metapackage
apt update && apt install kali-linux-default
```

### 3. Display Configuration

The Waveshare 5" is native portrait. Set orientation on first boot:

```bash
xrandr --output HDMI-1 --rotate left
```

To make this persistent, add it to `/etc/xdg/lxsession/LXDE/autostart` or your session manager's startup config.

---

## 📐 Design Philosophy

### The Single Source of Truth

> **`PROJECT_STATUS.md` governs all design decisions.** If a conflict arises between any two files in this repo, `PROJECT_STATUS.md` wins — no exceptions.

Chassis dimensions are **frozen at 138 × 195 × 65 mm**. This is not a suggestion. The internal cable management and airflow calculations depend on it. Do not modify without a full interior re-layout.

### Why These Choices?

- **Armbian over raw Debian:** Better Orange Pi 5B kernel support and hardware-specific patches out of the box.
- **LXC over Docker for Kali:** Full init system, proper systemd services, closer to bare-metal parity for tools that expect it.
- **PETG over PLA:** Better thermal tolerance, less warp at print time, more durable in field conditions.
- **I2C for OLEDs:** Minimizes GPIO pin usage; both displays share the bus with different addresses.

---

## 🗺 Roadmap

- [ ] Finalize chassis v5 print and fit-test
- [ ] Complete BBQ20 firmware customization (macro layer)
- [ ] OLED telemetry daemon (CPU · temp · IP · uptime)
- [ ] Kali LXC image snapshot + restore script
- [ ] Internal battery + power management integration
- [ ] Full build log with photos

---

## 👤 Owner

**K!MO** — Built for the field. Secured for the future.

---

<div align="center">
<sub>Governed by <code>PROJECT_STATUS.md</code> · Chassis frozen at 138 × 195 × 65 mm · All conflicts resolved by the single source of truth.</sub>
</div>
