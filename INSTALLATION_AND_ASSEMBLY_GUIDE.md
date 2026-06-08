# Cyberdeck Complete Installation & Assembly Guide

**Version:** 1.0  
**Last Updated:** 2026-05-25  
**Project:** Portable Cyberdeck (Orange Pi 5B + Waveshare 5" Screen + BBQ20 Keyboard)  
**Author:** K!MO

---

## Table of Contents

1. [Part 1: Kali Linux Installation on OPi5B](#part-1-kali-linux-installation-on-opi5b)
2. [Part 2: Hardware Connectivity Reference](#part-2-hardware-connectivity-reference)
3. [Part 3: OLED Display Integration](#part-3-oled-display-integration)
4. [Part 4: Screen Integration (Waveshare 5")](#part-4-screen-integration-waveshare-5)
5. [Part 5: Keyboard Integration (BBQ20)](#part-5-keyboard-integration-bbq20)
6. [Part 6: Final Assembly & Cabling](#part-6-final-assembly--cabling)
7. [Part 7: Post-Installation Configuration](#part-7-post-installation-configuration)

---

## Part 1: Kali Linux Installation on OPi5B

### 1.1 Prerequisites

**Hardware Required:**
- Orange Pi 5B (8GB RAM, 64GB eMMC)
- USB-C cable (for power and optional serial connection)
- MicroSD card reader (if updating firmware)
- Ethernet cable (for initial setup - highly recommended)
- External power supply (5V/4A minimum)
- Computer with `balena-etcher` or similar image writer

**Software Required:**
- Kali Linux image for ARM64 (OPi5B compatible)
- `balena-etcher` or `dd` command
- SSH client (built-in on macOS/Linux)

---

### 1.2 Why Kali Linux vs Stock Armbian?

**Current Status:** Your OPi5B is running **Armbian (Ubuntu 24.04 Noble)** with security hardening applied.

**Decision Logic:**
- ✅ **Keep Armbian as base** — more stable drivers for OPi5B hardware
- ✅ **Install Kali tools on top** — adds penetration testing utilities without losing OPi5B stability
- ❌ **Don't switch to pure Kali ARM image** — causes driver issues and screen integration problems

**Why?**
- Kali ARM images prioritize tools over hardware compatibility
- OPi5B HDMI/touch drivers are better supported on Armbian/Ubuntu
- You get **all Kali security tools** by running `apt install kali-tools-*` on Armbian

---

### 1.3 Option A: Installing Kali Tools on Existing Armbian (RECOMMENDED)

If your OPi5B already has Armbian Ubuntu 24.04 with SSH working, **use this approach** for fastest deployment.

#### Step 1: SSH into OPi5B

```bash
# From your Mac, SSH to OPi using static IP or hostname
ssh kimo@192.168.1.200

# Or if using Ethernet:
ssh kimo@192.168.1.199
```

#### Step 2: Add Kali Repository

```bash
# Update package lists first
sudo apt update
sudo apt upgrade -y

# Add Kali repository to APT sources
echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list.d/kali.sources.list

# Add Kali GPG key
wget -q -O - https://archive.kali.org/archive-key.asc | sudo apt-key add -

# Update package lists again to include Kali packages
sudo apt update
```

**Expected Output:**
```
Get:1 http://http.kali.org/kali kali-rolling InRelease [44.8 kB]
Get:2 http://http.kali.org/kali kali-rolling/main arm64 Packages [19.2 MB]
...
Reading package lists... Done
```

#### Step 3: Install Kali Tool Categories

Choose which tools you need (install selectively to save space):

**Option A: Essential penetration testing tools only (lightweight)**
```bash
sudo apt install -y kali-tools-top10
```

**Option B: Network security tools**
```bash
sudo apt install -y \
  nmap \
  netcat-openbsd \
  tcpdump \
  aircrack-ng \
  wireshark \
  metasploit-framework
```

**Option C: Full Kali metapackage (WARNING: 8GB+ installation)**
```bash
sudo apt install -y kali-linux-complete
```

**Option D: Forensics & data recovery**
```bash
sudo apt install -y kali-tools-forensics
```

#### Step 4: Verify Installation

```bash
# Check that Kali tools are available
which nmap
which msfconsole
which aircrack-ng

# Should return paths like:
# /usr/bin/nmap
# /usr/bin/msfconsole
# /usr/sbin/aircrack-ng
```

---

### 1.4 Option B: Full Kali Linux Installation (Fresh Image)

If you need a completely clean Kali install, follow this process:

#### Step 1: Download Kali ARM Image

```bash
# On your Mac, create a working directory
mkdir ~/kali-install && cd ~/kali-install

# Download latest Kali ARM image for OPi5B (or similar ARM64)
# Visit: https://www.kali.org/get-kali/#kali-arm

# Example download (check Kali official site for current version):
wget https://cdimage.kali.org/kali-linux-2024.1-rpi-nexmon-arm64.img.xz
# (Note: Use OPi5B-compatible ARM64 image, not Raspberry Pi specific)

# Extract the image
xz -d kali-linux-2024.1-*.img.xz
```

#### Step 2: Prepare OPi5B Storage

**Option A: Write to eMMC (via USB)**

1. Boot OPi5B into **Maskrom mode** (recovery mode)
   - Power OFF the OPi5B
   - Locate the small button labeled **RECOVERY** on the board
   - Hold RECOVERY button, then apply USB power
   - Board enters Maskrom mode

2. Use **OPi Flash Tool** (Allwinner image writer)
   - Download from Orange Pi official website
   - Select the extracted Kali image
   - Write to eMMC (internal storage)
   - Wait ~5-10 minutes

**Option B: Boot from MicroSD card**

1. Insert MicroSD into card reader on Mac
2. Identify disk:
   ```bash
   diskutil list
   # Find /dev/diskX (where X is a number)
   ```

3. Unmount and write:
   ```bash
   diskutil unmountDisk /dev/diskX
   sudo dd if=kali-linux-2024.1-*.img of=/dev/rdiskX bs=4m
   sync
   ```

4. Insert MicroSD into OPi5B and boot

#### Step 3: First Boot & SSH Setup

```bash
# Initial credentials are usually:
# username: root
# password: toor  (or kali/kali depending on image)

# SSH from your Mac
ssh root@192.168.1.200  # or obtain IP from your router

# Change default password (CRITICAL)
passwd

# Create new non-root user
useradd -m -s /bin/bash kimo
usermod -aG sudo kimo
passwd kimo

# Set up SSH key authentication (see Part 1.5 below)
```

---

### 1.5 SSH Hardening (Same for Both Options)

Once Kali tools are installed or Kali is booted, secure SSH immediately:

#### Step 1: Generate SSH Key (On Your Mac)

```bash
# Create SSH key pair (if you don't already have one)
ssh-keygen -t ed25519 -f ~/.ssh/opi5b_key -C "kimo@opi5b"

# Press Enter when prompted for passphrase (or use strong passphrase)
```

#### Step 2: Copy Public Key to OPi5B

```bash
# From Mac, copy key to OPi
ssh-copy-id -i ~/.ssh/opi5b_key.pub -p 22 kimo@192.168.1.200

# Or manually:
cat ~/.ssh/opi5b_key.pub | ssh kimo@192.168.1.200 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

#### Step 3: Disable Password SSH Login

```bash
# SSH into OPi
ssh -i ~/.ssh/opi5b_key kimo@192.168.1.200

# Edit SSH config
sudo nano /etc/ssh/sshd_config

# Find these lines and change them:
# PasswordAuthentication yes  →  PasswordAuthentication no
# KbdInteractiveAuthentication yes  →  KbdInteractiveAuthentication no
# PermitRootLogin yes  →  PermitRootLogin no
# PubkeyAuthentication yes  (leave as yes)

# Save with Ctrl+X, Y, Enter

# Reload SSH daemon
sudo systemctl reload ssh

# Verify configuration
sudo sshd -T | grep -E 'passwordauthentication|pubkeyauthentication|permitrootlogin'
```

Expected output:
```
passwordauthentication no
pubkeyauthentication yes
permitrootlogin no
```

#### Step 4: Firewall Setup

```bash
# Enable UFW firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp

# Allow only SSH, block everything else
sudo ufw enable

# Verify status
sudo ufw status verbose
```

---

### 1.6 First Boot Verification Checklist

Run these commands to verify everything is working:

```bash
# System identity
cat /etc/os-release | grep PRETTY_NAME
uname -r

# Network connectivity
ip -br a
ping -c 3 1.1.1.1
ping -c 3 google.com

# Kali tools verification
nmap --version
msfconsole --version  # (if installed)
aircrack-ng --version  # (if installed)

# Storage space check
df -h

# SSH hardening audit
sudo sshd -T | egrep 'passwordauthentication|kbdinteractiveauthentication|permitrootlogin|pubkeyauthentication'
```

---

## Part 2: Hardware Connectivity Reference

### 2.1 Orange Pi 5B Port Map

```
┌─────────────────────────────────────┐
│  OPi5B BOARD LAYOUT (100mm × 62mm)  │
└─────────────────────────────────────┘

┌─ TOP EDGE (100mm) ─────────────────┐
│ WiFi Ant1  WiFi Ant2  MicroSD  LED │  ← Pigtail cables & expansion
└─────────────────────────────────────┘
│                                     │
│  LEFT EDGE          RIGHT EDGE      │
│  ┌────────┐        ┌────────┐     │
│  │ Power  │        │ USB3.0 │     │
│  │ Button │        │ Type-A │     │
│  │        │        │        │     │
│  │  MIC   │        │ USB2.0 │     │
│  │ (3.5mm)│        │ Type-A │     │
│  │        │        │        │     │
│  │        │        │Ethernet│     │
│  │        │        │  (RJ45)│     │
│  └────────┘        └────────┘     │
│                                     │
│  SoC: Rockchip RK3588S             │
│  RAM: 8GB LPDDR4X                  │
│  Storage: 64GB eMMC                │
│                                     │
└─────────────────────────────────────┘
┌─ BOTTOM EDGE (100mm) ──────────────┐
│ USB-C Power  HDMI OUT  USB-C 3.0   │  ← Internal cables in cyberdeck
└─────────────────────────────────────┘

GPIO HEADER (26-pin, top edge):
  Pins 1-2:   3.3V power
  Pins 3-4:   I2C1 (SDA/SCL) — used for OLED1
  Pins 5-6:   GND
  Pins 9-10:  I2C4 (SDA/SCL) — used for OLED2
  (See pinout diagram in Part 3 for full mapping)
```

### 2.2 Cyberdeck Internal Cable Plan

```
COMPLETE INTERNAL WIRING DIAGRAM:

┌──────────────────────────────────────────────────┐
│   CYBERDECK INTERNAL CABLE ROUTING (Side View)   │
└──────────────────────────────────────────────────┘

FRONT WALL (Y = 0mm):
  ┌─────────────────────────────────┐
  │   Screen Display Window         │
  │   (Waveshare 5" HDMI LCD)       │
  │   Resolution: 720×1280          │
  │   Mount: Portrait, 69×128mm     │
  │   Interface: HDMI + USB-C       │
  └─────────────────────────────────┘

INTERNAL DEPTH LAYERS (Y-axis):
  Y = 0 to 2.5mm    → Front wall
  Y = 2.5 to 5.5mm  → Screen PCB (3mm board)
  Y = 5.5 to 34.4mm → Cable routing space (28.9mm — plenty!)
  Y = 34.4 to 39.4mm → Heatsinks (on top of OPi, vertical)
  Y = 39.4 to 41mm  → OPi 5B board (1.6mm)
  Y = 41 to 44mm    → Standoffs (3mm)
  Y = 44 to 47mm    → Back plate

CABLES ROUTED IN Y = 5.5 to 34.4mm SPACE:
  1. HDMI Flat Cable (OPi → Screen)      ~3mm thick, 15cm long
  2. USB-C to USB-C (Screen → OPi)       ~4mm thick, 10cm long
  3. USB-A to USB-C (Keyboard → OPi)     ~3mm thick, 10cm long
  4. I2C Dupont Wires (×2 for OLEDs)     ~2mm each, 15cm long

TOTAL CABLE SPACE USED: ~15mm
AVAILABLE SPACE: 28.9mm
SAFETY MARGIN: 13.9mm (1.93× factor) ✓
```

### 2.3 Power Delivery Plan

```
External Power Flow:
┌──────────────────┐
│  USB-C Charger   │ 5V/4A
│  or Power Bank   │
└────────┬─────────┘
         │ USB-C cable (13cm)
         ↓
    ┌─────────┐
    │ Case    │ Bottom edge port cutout
    │ Bottom  │
    └────┬────┘
         │ (short internal jumper)
         ↓
    ┌──────────────────────┐
    │ OPi 5B USB-C Power   │
    │ Input (5V/4A)        │
    └──────────────────────┘
         │
         ├─→ 5V Rail (3.3V regulator on board)
         ├─→ Powers: SoC, RAM, eMMC, WiFi, USB hubs
         └─→ Powers: Waveshare screen (via USB-C from OPi)
              Powers: BBQ20 keyboard (via USB-A from OPi)
              Powers: OLEDs (from GPIO 3.3V rail)

USB Data Flow:
  OPi USB3.0 Type-C ← Waveshare Screen (touch + power)
  OPi USB2.0 Type-A ← BBQ20 Keyboard (HID + optional power)

Note: All data is carried over USB; no separate serial connections
needed for these devices (they're standard HID/USB-CDC devices).
```

---

## Part 3: OLED Display Integration

### 3.1 OLED Module Specifications

You have **×5 OLED displays** (0.96" I2C type):

**Technical Specs:**
- Resolution: 128 × 64 pixels
- Interface: I2C (4-wire: VCC, GND, SCL, SDA)
- Voltage: 3.3V to 5V (OPi GPIO compatible: 3.3V)
- I2C Address: 0x3C (default) or 0x3D (if address pin pulled)
- Power Draw: 0.06W per display
- Physical Size: 27mm × 27mm PCB (LCD panel: 26.7mm × 19.3mm)
- Mounting: 4× M2 holes (or double-sided VHB tape)

**Color Variants:**
- 3× Yellow/Blue (partial color top rows)
- 2× Monochrome White

### 3.2 OPi5B GPIO I2C Pinout

```
OPi5B GPIO Header (26-pin, top edge of board):

    Pin 1 (3.3V) ─────┬─────────────────────┐
    Pin 2 (5V)       │                       │
    Pin 3 (I2C1 SDA) ├─ I2C1 Bus (OLED1)    │
    Pin 4 (GND)      │ Address: 0x3C        │
    Pin 5 (I2C1 SCL) │                       │
    Pin 6 (GND)      │                       │
    ...                                      │
    Pin 9 (GND)      │                       │
    Pin 10 (I2C4 SCL)├─ I2C4 Bus (OLED2)   │
    Pin 11 (I2C4 SDA)│ Address: 0x3C        │
    Pin 12 (GND)     │ (separate bus avoids  │
    ...              │  address conflict)    │
    Pin 26 (GND)     └─────────────────────┘

Standard 26-pin RPi-compatible GPIO layout:
┌─── ─── ─── ─── ─── ─── ─── ─── ─── ─── ─── ─── ─── ───┐
│ 1   2   3   4   5   6   7   8   9  10  11  12  13  14  │
│ +3V3 +5V SDA GND SCL GND NC NC GND CL  SDA GND NC NC   │
│                                        (I2C4)          │
│15  16  17  18  19  20  21  22  23  24  25  26          │
└─── ─── ─── ─── ─── ─── ─── ─── ─── ─── ─── ───┘

Full pin mapping available at: http://linux-sunxi.org/GPIO
(Note: OPi5B uses Rockchip RK3588S, pinout similar to RPi but verify!)
```

### 3.3 Hardware Wiring

**Connection for OLED1 (Upper Display):**

```
OLED1 PCB Pin          OPi5B GPIO Pin
─────────────────────────────────────
VCC (3.3V)      →     Pin 1 (3.3V)
GND             →     Pin 4 or 6 (GND)
SCL             →     Pin 5 (I2C1 SCL)
SDA             →     Pin 3 (I2C1 SDA)

Cable: 4-pin Female-to-Female Dupont wires (10cm)
Type: 2.54mm pitch DuPont connector
```

**Connection for OLED2 (Lower Display):**

```
OLED2 PCB Pin          OPi5B GPIO Pin
─────────────────────────────────────
VCC (3.3V)      →     Pin 1 (3.3V)
GND             →     Pin 9 or 12 (GND)
SCL             →     Pin 10 (I2C4 SCL)
SDA             →     Pin 11 (I2C4 SDA)

Cable: 4-pin Female-to-Female Dupont wires (10cm)
Type: 2.54mm pitch DuPont connector
```

**Why Two I2C Buses?**
- Both OLEDs have default address 0x3C
- Connecting to same bus = address collision → only one works
- OPi5B has **4 independent I2C controllers**
- Solution: Use I2C1 for OLED1, I2C4 for OLED2
- Each bus can have one 0x3C device independently

### 3.4 Software Setup

#### Step 1: Enable I2C on OPi5B

```bash
# SSH into OPi
ssh kimo@192.168.1.200

# Check if I2C is loaded
lsmod | grep i2c_dev

# Should show:
# i2c_dev            24576  0
# i2c_core           61440  8 i2c_dev,i2c_smbus,i2c_designware_platform,i2c_designware_core,...

# If not loaded, enable it
sudo modprobe i2c_dev

# Check I2C buses
i2cdetect -l

# Should show:
# i2c-0   smbus           Synopsys DesignWare adapter        SMBus adapter
# i2c-1   i2c             Synopsys DesignWare adapter        I2C adapter
# i2c-4   i2c             Synopsys DesignWare adapter        I2C adapter
# ... (etc)
```

#### Step 2: Scan for OLED Devices

```bash
# Install I2C tools (if not already present)
sudo apt install -y i2c-tools

# Scan I2C1 bus (OLED1)
i2cdetect -y 1

# Expected output (if OLED1 connected):
#      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
# 00:                         -- -- -- --
# 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 30: -- -- -- -- -- -- -- -- -- -- -- -- 3c -- -- --
# 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# ...
# (Shows "3c" which is 0x3C in decimal = OLED at I2C1)

# Scan I2C4 bus (OLED2)
i2cdetect -y 4

# Should also show device at 0x3C
```

#### Step 3: Install OLED Python Library

```bash
# Install required packages
sudo apt install -y python3-dev python3-pip python3-pil

# Install Adafruit SSD1306 library (works with our 0.96" OLEDs)
pip3 install adafruit-circuitpython-ssd1306 adafruit-circuitpython-busio

# OR install luma.oled (alternative, more features)
pip3 install luma.oled luma.core
```

#### Step 4: Test OLED1 (via Python)

```bash
# Create test script
cat > ~/oled_test.py << 'EOF'
#!/usr/bin/env python3

import board
import busio
import adafruit_ssd1306
from PIL import Image, ImageDraw, ImageFont

# Initialize I2C bus 1 (OLED1)
i2c = busio.I2C(board.SCL1, board.SDA1)

# Create display object (128×64 pixels)
display = adafruit_ssd1306.SSD1306_I2C(128, 64, i2c, addr=0x3C)

# Create blank image
image = Image.new('1', (128, 64))
draw = ImageDraw.Draw(image)

# Draw text
draw.text((0, 0), "OLED1 Test", fill=255)
draw.text((0, 20), "I2C Bus: 1", fill=255)
draw.text((0, 40), "Address: 0x3C", fill=255)

# Display image
display.image(image)
display.show()

print("✓ OLED1 display test complete!")
EOF

# Run test
python3 ~/oled_test.py
```

**Expected Result:** Text appears on OLED1 display

#### Step 5: Test OLED2 (via Python)

```bash
# Create test script for OLED2
cat > ~/oled_test2.py << 'EOF'
#!/usr/bin/env python3

import board
import busio
import adafruit_ssd1306
from PIL import Image, ImageDraw

# Initialize I2C bus 4 (OLED2)
i2c = busio.I2C(board.SCL4, board.SDA4)

# Create display object
display = adafruit_ssd1306.SSD1306_I2C(128, 64, i2c, addr=0x3C)

# Create blank image
image = Image.new('1', (128, 64))
draw = ImageDraw.Draw(image)

# Draw test pattern
draw.rectangle((0, 0, 127, 63), outline=255)
draw.text((30, 25), "OLED2 Test", fill=255)

# Display
display.image(image)
display.show()

print("✓ OLED2 display test complete!")
EOF

# Run test
python3 ~/oled_test2.py
```

#### Step 6: Persistent I2C Module Load

```bash
# Add I2C modules to startup
echo "i2c_dev" | sudo tee -a /etc/modules

# Verify
cat /etc/modules | grep i2c_dev
```

### 3.5 OLED in Case Cutouts

```
Right Wall Port Map (Cyberdeck Case):

OLED1 (Upper):
  Position: Z = 148–168mm from case bottom
  Window: 27.5mm wide × 19.8mm tall
  Mounting: 4× M2 screws through aluminum frame

OLED2 (Lower):
  Position: Z = 60–80mm from case bottom
  Window: 27.5mm wide × 19.8mm tall
  Mounting: 4× M2 screws through aluminum frame

Internal routing:
  OLED PCBs (×2) → 4-pin Dupont cables (15cm) → OPi GPIO header
  Cables bundled with HDMI flat cable in Y = 5.5-34.4mm routing space
```

---

## Part 4: Screen Integration (Waveshare 5")

### 4.1 Waveshare 5" HDMI LCD Specifications

```
DISPLAY MODULE SPECS:
┌─────────────────────────────────────┐
│ Waveshare 5" HDMI IPS LCD DSI-TOUCH │
└─────────────────────────────────────┘

Physical:
  Aluminum Frame Size: 128mm × 68.7mm (landscape)
  PCB Size: 110.4mm × 62.1mm
  Depth: 12mm
  Weight: ~150g
  
Display:
  Resolution: 720 × 1280 pixels (NATIVE PORTRAIT MODE)
  Format: IPS LCD, 5-point capacitive touch
  Brightness: 300 lm
  Viewing Angle: 170° (IPS)
  Color: 16-bit RGB
  Aspect Ratio: 9:16 (portrait)

Interfaces:
  Video: HDMI (full-size connector on bottom of PCB)
  Power + Touch: USB-C connector (top-left of PCB)
  Protocol: USB HID for touch coordinates
  
Power:
  Input: 5V via USB-C
  Current Draw: ~1.5A (display) + 0.1A (touch controller)
  Total: ~1.6A @ 5V
```

### 4.2 Wiring Diagram

```
OPi5B ← → Waveshare 5" Screen

VIDEO PATH (HDMI):
  OPi5B HDMI OUT (bottom edge)
    ↓ flat ribbon HDMI cable (~15cm)
  Waveshare HDMI IN (bottom of PCB)
  
  ⚠️ CRITICAL: Use FLAT/FPC HDMI cable (only 2-3mm thick)
     Standard HDMI too thick for internal routing!

POWER + TOUCH (USB-C):
  OPi5B USB3.0 Type-C (bottom edge)
    ↓ USB-C to USB-C cable (~10cm)
  Waveshare USB-C (top-left of PCB)
    ├─ Carries 5V power (from OPi's 5V rail)
    └─ Carries touch data (HID protocol)

POWER FLOW:
  External 5V/4A → OPi USB-C input
                 ↓
  OPi 5V rail (via onboard regulator)
                 ↓
  OPi USB3.0 Type-C output (5V passthrough)
                 ↓
  Waveshare USB-C (powers LCD + touch controller)
  
  ✓ One cable = video + power + touch data
  ✓ No separate power connection needed
```

### 4.3 Installation Steps

#### Step 1: Verify HDMI Output on OPi5B

```bash
# SSH to OPi
ssh kimo@192.168.1.200

# Check HDMI is detected
xrandr

# Expected output:
# HDMI-1 connected 720x1280+0+0 (normal left inverted right x axis y axis) 69mm x 128mm
#    1280x720_60.00   59.97 +

# If not detected, try:
sudo xrandr --output HDMI-1 --mode 720x1280 --rate 60
```

#### Step 2: Rotate Display to Portrait (If Needed)

```bash
# Check current rotation
xrandr --query

# Set portrait orientation (native for this screen)
xrandr --output HDMI-1 --rotate left

# Verify
xrandr --query | grep HDMI
```

#### Step 3: Verify Touch Input

```bash
# List input devices
ls -la /dev/input/

# Monitor touch events (real-time)
sudo cat /dev/input/event0 | od -An -tx1

# Touch the screen — should see rapid hex output

# Or use libinput for prettier output
sudo apt install -y libinput-tools
sudo libinput debug-events --device /dev/input/event0
```

#### Step 4: Test Display Output

```bash
# Create a test pattern (white screen)
xset s off
xset -dpms

# Display solid color
cat > ~/display_test.py << 'EOF'
import os
os.system("xrandr --output HDMI-1 --mode 720x1280")
os.system("xset s off -dpms")

# Open blank window at full brightness
import subprocess
subprocess.run(["feh", "--randomize", "--full-screen", "-d", "-N"])
EOF

# Or simply display a color:
# Create 720×1280 test image and display with feh, eog, etc.
```

#### Step 5: Set Screen as Primary Display (Optional)

```bash
# Make Waveshare the only display
xrandr --output HDMI-1 --primary --mode 720x1280 --rate 60
xrandr --output HDMI-1 --set "Broadcast RGB" "Full"

# Make permanent by adding to ~/.xinitrc or display manager config
echo "xrandr --output HDMI-1 --primary --mode 720x1280 --rate 60" >> ~/.bashrc
```

### 4.6 Case Mounting

```
SCREEN MOUNTING IN CYBERDECK CASE:

Front cavity:
  Screen window cutout: 69mm wide × 128mm tall
  Mounted on 1.5mm ledge (Y = 2.5-4mm from front)
  
Assembly steps:
  1. Apply thermal paste to OPi rear (if passive cooling)
  2. Lay OPi flat in cavity (standoffs at Y=41mm)
  3. Route HDMI & USB-C cables through 5.5-34.4mm routing space
  4. Position screen ledge at Y=2.5mm step
  5. Mount screen with 4× M2 screws through aluminum frame
  6. Cables should NOT be visible through transparent PETG case

Cable routing in internal cavity:
  All cables bundled flat against rear surface
  No cables blocking display visibility through front window
```

---

## Part 5: Keyboard Integration (BBQ20)

### 5.1 BBQ20 PCB Specifications

```
BBQ20 KEYBOARD CONTROLLER:

Board:
  Size: 79.08mm × 52.10mm
  Thickness: ~1.6mm (standard PCB)
  Mounting: 7× M2.5 holes around perimeter
  SoC: Raspberry Pi RP2040 (dual-core ARM)
  Flash: 16MB SPI (W25Q16)
  
Q20 Keyboard Interface:
  Connector: Hirose BM20B FPC (40-pin, 0.4mm pitch)
  Position: Bottom of BBQ20 PCB (exits toward case bottom)
  Keyboard: Q20 salvaged from old phone (~67.5mm × 41.5mm)
  Keys: QWERTY matrix + various function keys
  
USB Interface:
  Connector: USB-C on BBQ20 PCB
  Protocol: USB HID (appears as keyboard + optional trackpad)
  Power Draw: <100mA @ 5V
  Data: Full-speed USB 2.0 (12 Mbps)
  
Programmable Buttons:
  SW3 & SW4: Exposed on right edge of PCB
  Accessible through case cutouts (holes in right wall)
  Can be remapped via firmware or udev rules
```

### 5.2 Wiring Diagram

```
OPi5B → BBQ20 Keyboard → Q20 Keyboard Matrix

DATA PATH:
  OPi5B USB2.0 Type-A (right wall, internal)
    ↓ USB-A to USB-C adapter/cable (~10cm)
  BBQ20 PCB USB-C connector
    ↓ (USB HID protocol)
  RP2040 firmware decodes keyboard matrix
    ↓
  Q20 FPC ribbon connects to Hirose CN1
    └─ Keyboard matrix: ~67.5mm × 41.5mm

POWER:
  OPi5B 5V rail (via USB2.0)
    ↓
  BBQ20 board 5V input
    ↓
  RP2040 + keyboard matrix powered

NO MODIFICATION REQUIRED:
  ✓ BBQ20 PCB comes pre-programmed with HID firmware
  ✓ Plug USB-C into OPi, keyboard immediately recognized
  ✓ Appears as /dev/input/event* on Linux
```

### 5.3 Installation Steps

#### Step 1: Connect BBQ20 via USB

```bash
# From OPi, SSH and verify USB connection
ssh kimo@192.168.1.200

# List USB devices before connecting keyboard
lsusb

# Connect BBQ20 USB-C to OPi USB2.0 Type-A (right wall, internal)

# Wait 2 seconds, then list USB again
lsusb

# Should see new device appear:
# Bus 002 Device 003: ID xxxx:yyyy BBQ20 Keyboard / RP2040

# Get detailed info
lsusb -v | grep -A 20 "BBQ20\|RP2040"
```

#### Step 2: Verify HID Device

```bash
# List input devices
cat /proc/bus/input/devices

# Look for BBQ20 entry:
# N: Name="BBQ20 Keyboard"
# P: Phys=usb-...
# S: Sysfs=/devices/platform/.../input/input0
# U: Uniq=...
# H: Handlers=sysrq kbd event0

# Check which event device corresponds to BBQ20
ls -la /dev/input/

# Test keyboard input
sudo cat /dev/input/eventX | od -An -tx1

# Type on Q20 keyboard — should see hex data streaming
```

#### Step 3: Verify Key Mapping

```bash
# Install evtest for interactive testing
sudo apt install -y evtest

# Run evtest on BBQ20 device
sudo evtest /dev/input/eventX

# Follow prompts, press keys on Q20 keyboard
# Each key press should show event with keycode

# Example output:
# Event: time 1234.567890, type 1 (EV_KEY), code 30 (KEY_A), value 1
# Event: time 1234.567891, type 1 (EV_KEY), code 30 (KEY_A), value 0
```

#### Step 4: Test in Terminal

```bash
# Open terminal or SSH session
ssh kimo@192.168.1.200

# Type on Q20 keyboard — characters should appear
# Try: abcdefghijklmnopqrstuvwxyz
# Try: 0123456789
# Try: !@#$%^&*()

# If characters appear correctly, keyboard is working ✓

# Test special keys
# Press Shift+A for capital letter
# Press Enter/Return
# Press Backspace
# Press Tab

# All should behave as normal USB keyboard
```

#### Step 5: Configure Button Remapping (Optional)

```bash
# If you want to remap SW3 or SW4 buttons:

# Create a custom keymap in /etc/udev/hwdb.d/
sudo nano /etc/udev/hwdb.d/99-bbq20-keymap.hwdb

# Add custom mappings (example: remap SW3 to F1):
keyboard:name:BBQ20 Keyboard:*
 KEYBOARD_KEY_90001=f1      # SW3 → F1 key
 KEYBOARD_KEY_90002=f2      # SW4 → F2 key

# Rebuild udev database
sudo udevadm hwdb --update

# Reboot or reconnect keyboard to apply
sudo reboot
```

#### Step 6: Persistent Connection

```bash
# Make keyboard reconnect automatically after reboot
echo "# BBQ20 Keyboard auto-reconnect" | sudo tee -a /etc/rc.local

# Optional: Create a systemd service to monitor BBQ20
sudo nano /etc/systemd/system/bbq20-monitor.service

# Add:
[Unit]
Description=BBQ20 Keyboard Monitor
After=multi-user.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/watch -n 1 'lsusb | grep -i rp2040'
Restart=always

[Install]
WantedBy=multi-user.target

# Enable service (optional)
sudo systemctl enable bbq20-monitor.service
```

---

## Part 6: Final Assembly & Cabling

### 6.1 Pre-Assembly Checklist

- [ ] OPi5B powered on and SSH working
- [ ] Kali tools installed and verified
- [ ] OLED displays tested via I2C (both showing text)
- [ ] Waveshare screen confirmed working over HDMI + USB-C
- [ ] BBQ20 keyboard recognized as HID device
- [ ] All cables prepared (flat HDMI, USB-C, USB-A, Dupont wires)
- [ ] Case 3D printed and ready
- [ ] Standoffs, screws, thermal paste ready
- [ ] Heatsinks applied to OPi chips
- [ ] External power supply tested (5V/4A)

### 6.2 Assembly Order

**Phase 1: Prepare OPi5B**

```bash
# Power OFF OPi5B
sudo poweroff

# Wait for shutdown (5 seconds)
# Disconnect power cable

# Physical prep:
# 1. Apply thermal paste to RK3588S SoC and RAM chips
#    (thin layer, ~1mm; use thermal compound)
#
# 2. Apply copper heatsinks on top of chips
#    (use thermal adhesive tape if not already applied)
#
# 3. Mount 4× M2.5 standoffs on case interior
#    at positions: ±3.5mm from corners in X, Y=41mm
```

**Phase 2: Install OPi5B in Case**

```
In case cavity:
  1. Position OPi5B on standoffs
     - Right edge flush with right inner wall (X = 133mm)
     - Bottom at Z = 47.5mm
     - Secure with 4× M2.5 × 6mm screws
  
  2. Route WiFi antenna cables
     - Pigtail #1 → hole in top-left of case
     - Pigtail #2 → hole in top-right of case
     - Both FPC patches stuck inside case walls
  
  3. Route HDMI flat cable
     - OPi HDMI OUT (bottom edge) → bundle with other cables
     - Path through Y = 5.5-34.4mm space (along rear)
     - Endpoint: Waveshare HDMI IN (bottom of screen PCB)
  
  4. Route USB-C power + touch cable
     - OPi USB3.0 Type-C → Waveshare USB-C (top-left)
     - Same cable path as HDMI (bundled)
     - Length: ~10cm
  
  5. Route USB-A to USB-C (keyboard cable)
     - OPi USB2.0 Type-A → BBQ20 USB-C
     - Route through cavity alongside other cables
     - Length: ~10cm
  
  6. Prepare Dupont wires for OLEDs
     - OLED1 (I2C1) → 4-pin wires to GPIO pins 3, 4, 5, 6
     - OLED2 (I2C4) → 4-pin wires to GPIO pins 10, 11, 9, 12
     - Bundle separately from main cables
     - Keep inside cavity, along interior walls
```

**Phase 3: Mount Screen**

```
Front face installation:
  1. Position Waveshare on ledge
     - Screen aluminum frame rests on 1.5mm lip (Y = 2.5-4mm)
     - Centered in window (69mm × 128mm visible area)
     - HDMI connector points downward (toward cable routing)
     - USB-C connector top-left (toward cable routing)
  
  2. Secure with 4× M2 × 6mm screws
     - One screw per corner of aluminum frame
     - Snug but not over-tightened (aluminum soft)
  
  3. Connect cables (all already routed from Phase 2)
     - HDMI: OPi → Waveshare
     - USB-C: OPi → Waveshare
     - Verify no tension on connectors
```

**Phase 4: Mount Keyboard + BBQ20 PCB**

```
Bottom cavity installation:
  1. Position BBQ20 PCB + Q20 keyboard assembly
     - Q20 keyboard keys facing downward (toward keyboard window)
     - BBQ20 PCB behind keyboard (toward interior)
     - FPC ribbon from Q20 plugged into Hirose CN1 on BBQ20
  
  2. Mount BBQ20 using 4× M2.5 screws
     - Through mounting holes in PCB into threaded inserts
     - SW3 & SW4 buttons align with right-wall cutouts
  
  3. Connect USB-C keyboard cable
     - BBQ20 USB-C ← OPi USB2.0 Type-A
     - Cable already routed in Phase 2
  
  4. Verify button accessibility
     - SW3 button pokes through right-wall hole at Z≈88mm
     - SW4 button pokes through right-wall hole at Z≈76mm
     - Both buttons externally pressable
```

**Phase 5: Install OLED Displays**

```
Right-wall OLED mounting:
  1. OLED1 (upper) at Z = 148–168mm
     - Position OLED PCB behind right-wall cutout
     - Mount with 4× M2 screws through aluminum frame
     - OR use double-sided VHB tape (PCB too thin for screws)
     - Connect Dupont wires: 4-pin to OPi GPIO I2C1
  
  2. OLED2 (lower) at Z = 60–80mm
     - Position OLED PCB behind right-wall cutout
     - Mount with 4× M2 screws or VHB tape
     - Connect Dupont wires: 4-pin to OPi GPIO I2C4
  
  3. Bundle Dupont wires
     - Route alongside main cables in Y = 5.5-34.4mm
     - No tension on GPIO header pins
     - Verify I2C SCL/SDA are not swapped
```

**Phase 6: Power Connections**

```
Bottom edge port management:
  1. USB-C Power Input
     - Mount female USB-C connector at case bottom (X ≈ 28mm)
     - Connect short internal jumper to OPi USB-C input
     - Cable should have strain relief / right-angle connector
  
  2. Audio 3.5mm Jack (optional)
     - Mount at case bottom (X ≈ 43mm)
     - If audio not used initially, leave as blank hole
  
  3. External power path
     - 5V/4A external charger → USB-C case port
     - Internal jumper → OPi USB-C
     - OPi onboard regulator splits power to:
       * 5V rail (USB hosts, Waveshare, BBQ20)
       * 3.3V rail (GPIO, OLEDs)
```

**Phase 7: Close Case**

```
Final assembly:
  1. Verify all cables routed correctly
     - No cables pinched between OPi and back wall
     - All connectors have 2-3mm clearance to walls
     - Cables bundled neatly (use cable ties if needed)
  
  2. Install back plate
     - 4× M2.5 screws at corners
     - Ventilation slots fully open
     - K!MO signature visible
  
  3. Final inspection
     - No visible cables through transparent PETG
     - Ports align with case cutouts
     - Screen visible through front window
     - Keyboard visible through front window
     - WiFi antenna holes open
     - MicroSD slot accessible
  
  4. Power cycle test
     - Connect 5V/4A charger to bottom USB-C port
     - Power on OPi using power button (left wall)
     - Verify:
       * OPi LED lights (top-right of case)
       * Screen boots Linux
       * OLEDs light up
       * No smoke or sparks ✓
```

### 6.3 Cable Assembly Diagram

```
FINAL INTERNAL CABLE LAYOUT (Top-Down View):

┌─────────────────────────────────────────┐
│        CYBERDECK (138mm × 195mm)        │
│     TOP-DOWN VIEW (Y-axis pointing up)  │
└─────────────────────────────────────────┘

Front (Screen):
┌───────────────────────────────────────────────┐
│   SCREEN WINDOW (69mm × 128mm)                │
│   ┌─────────────────────────────────┐       │
│   │  Waveshare 5" HDMI LCD Display  │       │
│   │  [720×1280 Portrait, Native]    │       │
│   └─────────────────────────────────┘       │
├───────────────────────────────────────────────┤

Interior (Cable routing & components):
│                                               │
│  ← HDMI flat cable (3mm) ────────┐           │
│                                   ↓           │
│  ← USB-C to USB-C (4mm) ──────────┤           │
│  ← USB-A to USB-C (3mm) ──────────┤           │
│  ← Dupont I2C wires ×2 (2mm) ─────┤           │
│                                   ↓           │
│  ┌─────────────────────────────────────┐    │
│  │  OPi5B (100mm × 62mm)              │    │
│  │  [RK3588S SoC + Heatsinks + GPIO]  │    │
│  └─────────────────────────────────────┘    │
│     ↑ All cables bundled along rear ↑       │

Keyboard (Bottom):
├───────────────────────────────────────────────┤
│   KEYBOARD WINDOW (69mm × 44mm)               │
│   ┌───────────────────────────────────┐     │
│   │  Q20 Keyboard + BBQ20 PCB         │     │
│   │  [USB HID + SW3/SW4 buttons]      │     │
│   └───────────────────────────────────┘     │
└───────────────────────────────────────────────┘

Right Wall (OLED displays):
    128mm
     ↓
   [OLED1] ← 27.5 × 19.8mm window
    ...
   [OLED2] ← 27.5 × 19.8mm window
     ↑
    60mm

Back:
   Ventilation slots (6× horizontal)
   K!MO signature vent cutout
   4× M2.5 screw holes (corners)
```

---

## Part 7: Post-Installation Configuration

### 7.1 First Boot Verification

```bash
# Power on cyberdeck using power button on left wall

# Wait 30 seconds for OPi to boot

# SSH from Mac
ssh kimo@192.168.1.200

# Check all systems are responsive
echo "Checking system status..."

# CPU temperature (should be <50°C with heatsinks)
cat /sys/class/thermal/thermal_zone0/temp

# Display output
xrandr

# HDMI display connected?
# HDMI-1 connected 720x1280+0+0

# I2C buses
i2cdetect -l

# OLED devices
i2cdetect -y 1   # Shows 0x3C for OLED1
i2cdetect -y 4   # Shows 0x3C for OLED2

# Keyboard HID
lsusb | grep -i rp2040

# WiFi status
ip -br a
nmcli dev status
```

### 7.2 Persistent WiFi Configuration

```bash
# Connect to WiFi (if not already connected)
ssh kimo@192.168.1.200

# List available networks
nmcli dev wifi list

# Connect to network
nmcli dev wifi connect "YOUR_SSID" password "YOUR_PASSWORD" ifname wlan0

# Check connection status
nmcli con show

# Make it autoconnect on boot
nmcli con modify "YOUR_SSID" connection.autoconnect yes

# Test persistence (reboot)
sudo reboot

# After reboot:
ssh kimo@192.168.1.200
ip -br a  # Should show WiFi IP immediately
```

### 7.3 OLED Status Dashboard (Optional)

```bash
# Create a Python script to display system info on OLEDs

cat > ~/cyberdeck_status.py << 'EOF'
#!/usr/bin/env python3
"""
Real-time system status display on dual OLED screens.
OLED1 (upper): CPU/RAM/Temp
OLED2 (lower): Network/WiFi
"""

import board
import busio
import adafruit_ssd1306
import psutil
from PIL import Image, ImageDraw
import socket
import subprocess
import time

# Initialize I2C buses
i2c1 = busio.I2C(board.SCL1, board.SDA1)
i2c4 = busio.I2C(board.SCL4, board.SDA4)

display1 = adafruit_ssd1306.SSD1306_I2C(128, 64, i2c1, addr=0x3C)
display2 = adafruit_ssd1306.SSD1306_I2C(128, 64, i2c4, addr=0x3C)

def get_cpu_temp():
    try:
        with open('/sys/class/thermal/thermal_zone0/temp') as f:
            return int(f.read()) / 1000
    except:
        return 0

def get_wifi_ssid():
    try:
        result = subprocess.run(['nmcli', '-t', '-f', 'active,ssid', 'dev', 'wifi'],
                              capture_output=True, text=True)
        for line in result.stdout.split('\n'):
            if line.startswith('yes'):
                return line.split(':')[1]
    except:
        return "N/A"

def get_wifi_signal():
    try:
        result = subprocess.run(['nmcli', '-t', '-f', 'signal', 'dev', 'wifi'],
                              capture_output=True, text=True)
        signal = result.stdout.strip().split('\n')[0]
        return signal
    except:
        return "N/A"

def update_display1():
    """CPU/RAM/Temp display"""
    image = Image.new('1', (128, 64))
    draw = ImageDraw.Draw(image)
    
    cpu_percent = psutil.cpu_percent(interval=1)
    ram_percent = psutil.virtual_memory().percent
    temp = get_cpu_temp()
    
    draw.text((0, 0), "=== CYBERDECK ===", fill=255)
    draw.text((0, 12), f"CPU: {cpu_percent:.1f}%", fill=255)
    draw.text((0, 24), f"RAM: {ram_percent:.1f}%", fill=255)
    draw.text((0, 36), f"Temp: {temp:.1f}C", fill=255)
    draw.text((0, 48), "Ready for hacking", fill=255)
    
    display1.image(image)
    display1.show()

def update_display2():
    """Network status display"""
    image = Image.new('1', (128, 64))
    draw = ImageDraw.Draw(image)
    
    wifi_ssid = get_wifi_ssid()
    wifi_signal = get_wifi_signal()
    
    # Get IP address
    try:
        ip = socket.gethostbyname(socket.gethostname())
    except:
        ip = "N/A"
    
    draw.text((0, 0), "=== NETWORK ===", fill=255)
    draw.text((0, 12), f"WiFi: {wifi_ssid}", fill=255)
    draw.text((0, 24), f"Signal: {wifi_signal}%", fill=255)
    draw.text((0, 36), f"IP: {ip}", fill=255)
    draw.text((0, 48), "Secure & Ready", fill=255)
    
    display2.image(image)
    display2.show()

# Main loop
if __name__ == "__main__":
    print("Starting cyberdeck status display...")
    try:
        while True:
            update_display1()
            time.sleep(2)
            update_display2()
            time.sleep(2)
    except KeyboardInterrupt:
        print("Stopped.")
EOF

# Run status display
python3 ~/cyberdeck_status.py
```

### 7.4 Kali Tools Verification

```bash
# Verify key penetration testing tools are working

echo "=== KALI TOOLS VERIFICATION ==="

# Network tools
echo "✓ Nmap"
nmap --version | head -1

echo "✓ Aircrack-ng"
aircrack-ng --version | head -1

echo "✓ Wireshark"
wireshark --version 2>/dev/null || echo "  (GUI only, headless OK)"

echo "✓ Metasploit"
msfconsole --version 2>&1 | head -1

echo "✓ Hashcat"
hashcat --version 2>/dev/null || echo "  (Optional, depends on GPU)"

echo "✓ John the Ripper"
john --version 2>&1 | head -1

# Test connectivity
echo ""
echo "=== NETWORK CONNECTIVITY ==="
ping -c 1 8.8.8.8 && echo "✓ Internet access verified"

# Check firewall
echo ""
echo "=== SECURITY STATUS ==="
sudo ufw status

# SSH hardening
echo ""
echo "=== SSH HARDENING ==="
sudo sshd -T | grep -E 'passwordauthentication|permitrootlogin|pubkeyauthentication'
```

### 7.5 Backup & Recovery

```bash
# Create a system backup (on external drive)

# SSH to OPi
ssh kimo@192.168.1.200

# Create compressed backup of critical directories
tar -czf cyberdeck_backup.tar.gz \
  /home/kimo/.ssh \
  /home/kimo/.kali \
  /etc/ssh \
  /etc/ufw \
  /etc/hostname \
  /etc/network

# Copy backup to external storage
scp cyberdeck_backup.tar.gz user@external-device:/backups/

# To restore (if needed):
# tar -xzf cyberdeck_backup.tar.gz -C /
```

### 7.6 Ongoing Maintenance

```bash
# Weekly updates (over SSH)
ssh kimo@192.168.1.200

# Update package lists and upgrade
sudo apt update
sudo apt upgrade

# Update Kali tools
sudo apt update kali-tools-*

# Check for security advisories
sudo needrestart -ra

# Monitor disk space
df -h

# Check for failed systemd services
sudo systemctl status --failed

# Monitor CPU/RAM usage
top -b -n 1 | head -20
```

---

## Troubleshooting Reference

### HDMI Display Not Detected

```bash
# 1. Check HDMI connection physical
#    Verify flat HDMI ribbon is fully inserted (click sound)

# 2. Force HDMI detection
xrandr --output HDMI-1 --auto

# 3. Check kernel messages for HDMI error
dmesg | grep -i hdmi

# 4. Restart display manager
sudo systemctl restart display-manager

# 5. If still not working, try different resolution
xrandr --output HDMI-1 --mode 1280x720 --rate 60
```

### Keyboard Not Recognized

```bash
# 1. Check USB connection
lsusb | grep -i rp2040

# 2. If not found, physically disconnect and reconnect
#    USB-A cable from OPi USB2.0 to BBQ20 USB-C

# 3. Check kernel messages
dmesg | tail -20

# 4. Re-enumerate USB bus
sudo sh -c 'echo 1 > /sys/bus/usb/devices/1-1/authorized'

# 5. If still not working, try different USB port
#    (Use OPi USB3.0 Type-A instead, with adapter)
```

### OLED Displays Not Showing

```bash
# 1. Check I2C bus detection
i2cdetect -y 1    # Should show 0x3C
i2cdetect -y 4    # Should show 0x3C

# 2. Check GPIO header connections
#    Verify Dupont wires are fully seated

# 3. Verify I2C buses are enabled
lsmod | grep i2c_dev
sudo modprobe i2c_dev  # If missing

# 4. Check power: measure 3.3V on GPIO pin 1
#    (use multimeter on OPi GPIO header)

# 5. Verify Python library installed
pip3 list | grep adafruit
pip3 list | grep luma

# 6. Test with simple Python script
python3 << 'PYEOF'
import board
import busio
try:
    i2c1 = busio.I2C(board.SCL1, board.SDA1)
    print("✓ I2C1 bus OK")
except Exception as e:
    print(f"✗ I2C1 error: {e}")
PYEOF
```

### WiFi Disconnects After Reboot

```bash
# 1. Check NetworkManager autoconnect setting
nmcli con show | grep autoconnect

# 2. Enable autoconnect
nmcli con modify "YOUR_SSID" connection.autoconnect yes

# 3. Make WiFi boot priority higher
sudo nano /etc/network/interfaces
# Add: auto wlan0

# 4. Check DHCP issues
sudo dhclient -v wlan0

# 5. Restart NetworkManager
sudo systemctl restart NetworkManager
```

### Slow Boot Time

```bash
# 1. Check boot sequence timing
systemd-analyze

# 2. Find slowest services
systemd-analyze blame

# 3. Disable unnecessary services
sudo systemctl disable bluetooth     # If not needed
sudo systemctl disable cups          # If not printing
sudo systemctl disable avahi-daemon  # If not using mDNS

# 4. Check for fsck delays
sudo systemctl status systemd-fsck@*

# 5. Optimize Kali package database (if slow)
sudo apt-get clean
sudo apt-get autoclean
```

---

## Quick Reference Commands

```bash
# SSH to OPi (Mac)
ssh kimo@192.168.1.200

# Check system status
uname -a
cat /proc/cpuinfo | head -5
free -h

# Network diagnostics
ping -c 3 1.1.1.1
traceroute google.com
nslookup google.com

# Display/screen commands
xrandr                              # List outputs
xrandr --output HDMI-1 --rotate left  # Rotate

# I2C commands
i2cdetect -l                        # List buses
i2cdetect -y 1                      # Scan bus 1 for devices

# USB commands
lsusb                               # List USB devices
lsusb -v -d xxxx:yyyy              # Verbose for specific device

# Keyboard input commands
evtest /dev/input/eventX            # Monitor key events
cat /dev/input/eventX | od -An -tx1  # Raw input dump

# SSH key management
ssh-keygen -t ed25519 -f ~/.ssh/opi5b_key
ssh-copy-id -i ~/.ssh/opi5b_key.pub kimo@192.168.1.200

# Firewall management
sudo ufw status verbose
sudo ufw allow 22/tcp
sudo ufw enable

# System updates
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade

# Kali tools installation
sudo apt install kali-tools-top10
sudo apt install nmap aircrack-ng wireshark
```

---

## Safety & Security Notes

### Power Management

- **Do NOT** power cycle while system is running
- **Always** use `sudo poweroff` or `sudo reboot` before disconnecting power
- Monitor temperature: `cat /sys/class/thermal/thermal_zone0/temp` (should be <70°C)
- If temperature exceeds 80°C, stop processing and let cool

### SSH Security

- **Never** share your private SSH key (`~/.ssh/opi5b_key`)
- **Always** keep SSH key passphrase strong (or use SSH agent)
- **Disable** password SSH login as documented in Part 1.5
- **Monitor** SSH attempts: `sudo tail -f /var/log/auth.log`

### Network Safety

- Use **UFW firewall** to block unnecessary ports
- **Isolate** cyberdeck on trusted network only
- **Avoid** public WiFi networks (use VPN if needed)
- **Monitor** bandwidth usage for abnormal activity

### Storage Safety

- **Backup** critical files regularly
- **Encrypt** sensitive data on microSD or external storage
- **Review** Kali tool logs periodically
- **Keep** OS and tools updated with `apt update && apt upgrade`

---

## Final Verification Checklist

- [ ] OPi5B boots reliably and stays on for 24+ hours
- [ ] SSH access works with key-based auth only
- [ ] HDMI display shows Ubuntu desktop at 720×1280 portrait
- [ ] Touch input responds to finger presses on screen
- [ ] Q20 keyboard types correctly in terminal
- [ ] Both OLED displays show system status (if using status script)
- [ ] WiFi connects automatically after reboot
- [ ] Nmap, Metasploit, and other Kali tools launch without error
- [ ] Firewall is active and SSH is the only allowed incoming service
- [ ] All internal cables are secured and not pinched
- [ ] Case closes completely with no gaps
- [ ] All port cutouts align correctly with hardware
- [ ] Power button on left wall works
- [ ] LED indicator on top shows activity

---

## Contact & Support

For hardware issues:
- Orange Pi official forum: http://www.orangepi.org/
- Check datasheet: OPi5B RK3588S technical reference

For Kali Linux:
- Official docs: https://www.kali.org/docs/
- Community forum: https://forums.kali.org/

For Waveshare screen:
- Product wiki: https://www.waveshare.com/wiki/5inch_HDMI_LCD
- Support: support@waveshare.com

---

**Happy hacking! 🚀**
