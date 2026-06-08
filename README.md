```markdown
# 📟 CYBERDECK v1 (Orange Pi 5B)

A portable, hardened, and field-ready cyberdeck built for stability and security. This project integrates high-performance ARM computing with tactile physical inputs and a modular "single source of truth" design philosophy.

![Project Status](https://img.shields.io/badge/Status-In--Progress-orange)
![OS](https://img.shields.io/badge/OS-Armbian%20(Ubuntu%2024.04)-blue)
![Architecture](https://img.shields.io/badge/Architecture-aarch64-green)

---

## 🎯 Mission
Build a portable, safe, and learnable cyberdeck that:
* **Boots reliably:** Uses a stable Armbian base with optional Kali toolsets.
* **Secure by default:** Hardened SSH, UFW firewall, and key-based authentication.
* **Tactile & Functional:** Integrated BBQ20 physical keyboard and portrait 5" touch display.
* **Maintainable:** Understandable internal wiring and a modular 3D-printed chassis.

---

## 🛠 Hardware Specifications

| Component | Detail |
| :--- | :--- |
| **Compute Core** | Orange Pi 5B (Rockchip RK3588S, 8GB RAM, 64GB eMMC) |
| **Primary Display** | Waveshare 5" HDMI LCD (720x1280 Native Portrait) |
| **Tactile Input** | BBQ20 USB/BLE Keyboard (RP2040-based) |
| **Status Displays** | 2x 0.96" I2C OLED Modules (SSD1306) |
| **Connectivity** | Wi-Fi 6, BT 5.0, Gigabit Ethernet, USB 3.0, GPIO |
| **Chassis** | Custom OpenSCAD design (PETG), 138mm x 195mm x 65mm |

---

## 🔐 Software Architecture & Security

The system runs a **Dual-Layer OS Strategy** to maximize hardware stability while providing a full security toolchain:

1. **Host OS (Stability):** Armbian (Ubuntu 24.04 Noble) running kernel `6.1.115-vendor`.
2. **Tooling Layer (Offensive):** Kali Linux running inside an **unprivileged LXC container**. This prevents "breaking" the host with cross-distro dependencies.
3. **Hardening:**
   * Password-based SSH login disabled.
   * Root SSH login disabled.
   * UFW Firewall enabled (default deny incoming).
   * `opi5b_postinstall.sh` script for automated baseline security.

---

## 🔌 Internal Connectivity & Routing

The chassis is designed with a **"Clean Interior"** philosophy. All cables are routed in a dedicated 28.9mm Y-axis cavity between the screen and the board.

### Cable Map
* **Video:** OPi HDMI OUT → Waveshare HDMI IN (Flat FPC Ribbon)
* **Touch/Power:** OPi USB-C 3.0 → Waveshare USB-C (HID Touch + Power)
* **Keyboard:** OPi USB-A 2.0 → BBQ20 USB-C (Internal HID Link)
* **Telemetry:** GPIO Header → Dual OLEDs (I2C1 and I2C4 buses)

### External Port Access
* **Right Wall:** USB 3.0 (exposed), Ethernet (exposed), Dual OLED Windows.
* **Left Wall:** Power Button, MIC hole.
* **Bottom Edge:** USB-C Power Input (External Charging), 3.5mm Audio.

---

## 📂 Project Structure

```text
.
├── scripts/              # Automation and post-install hardening
├── case/                 # OpenSCAD 3D design files (REVIEW-CASE.scad)
├── BBQ20-USB-keyboard/   # Firmware and hardware for the Q20 keyboard
├── Cyberdeck/            # PCB Gerber files and BOM
├── DESIGN_SPEC_v5.md     # Master geometric measurements
└── PROJECT_STATUS.md     # Current verified hardware/software state
🚀 Getting Started
1. Host Preparation
Flash Armbian to MicroSD/eMMC.
Run the post-install script:
Bash
sudo ./scripts/opi5b_postinstall.sh
Verify SSH key access and firewall status.
2. Kali LXC Setup (Optional)
To run Kali tools safely:
Install LXC on the host.
Create the container:
Bash
lxc-create -t download -n kali-arm64
Attach and install metapackages:
Bash
apt install kali-linux-default
3. Display Configuration
The Waveshare 5" is native portrait. Use xrandr to ensure correct orientation:
Bash
xrandr --output HDMI-1 --rotate left
📐 Design Philosophy: "The Single Source of Truth"
All design decisions are governed by PROJECT_STATUS.md. If a conflict arises between files, that document wins. The chassis dimensions are frozen at 138mm x 195mm x 65mm to allow for comfortable internal cable management and airflow.
👤 Owner
K!MO Built for the field. Secured for the future.
