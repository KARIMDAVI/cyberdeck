# Cyberdeck — Component Measurements Reference
> Last updated: 2026-04-15. All units in millimeters (mm) unless noted.
> These are verified values — do not guess port positions, always refer here first.

---

## Case (OpenSCAD Design) — UPDATED FOR 5" SCREEN

| Dimension | Value | Notes |
|-----------|-------|-------|
| Outer width (X) | **138mm** | Fits 68.7mm portrait screen + 34.65mm margins each side |
| Outer height (Z) | **195mm** ⬆️ from 175mm | Required for portrait screen (128mm) + keyboard (44mm) + 5mm gap |
| Outer depth (Y) | **65mm** | Fits 62mm OPi + 3mm margins |
| Wall thickness | 2.5mm | All edges |
| Corner radius | 6mm | Rounded sci-fi aesthetic |
| Back plate thickness | 3mm | Removable with 4× M2.5 screws |

### Front Face Windows
| Feature | Width | Height | Position | Notes |
|---------|-------|--------|----------|-------|
| Screen window | 69mm | 128mm | 8mm from top, centered (34.65mm each side) | Waveshare 5" — **PORTRAIT MOUNT** (rotated 90°) |
| Screen ledge (board rests on) | 130mm | — | 2mm step inside | Aluminum frame support |
| Keyboard window | 69mm | 44mm | 10mm from bottom, centered | BBQ20 keyboard visibility |

### Interior Cavity Redesign
| Dimension | Value | Change |
|-----------|-------|--------|
| Cavity width (X) | 133mm | Case 138mm - 2.5mm walls each side |
| Cavity height (Z) | **190mm** | Case 195mm - 2.5mm walls each edge |
| Cavity depth (Y) | 59.5mm | Case 65mm - 2.5mm front wall, 3mm back plate |
| Component layout | Screen front, OPi center, keyboard bottom | New spatial arrangement |

---

## BBQ20 PCB — ZitaoTech (Exact from Gerber files)

| Dimension | Value | Source |
|-----------|-------|--------|
| Board width | 79.08mm | Gerber BoardOutline |
| Board height | 52.10mm | Gerber BoardOutline |
| Top corner radius | 3.10mm | Gerber arcs |
| Bottom corner radius | 14.00mm | Gerber arcs |
| Mounting holes | 7× total | Gerber circles |
| Hole diameter | ~2.5mm (M2.5) | Gerber |
| FPC connector (CN1) | Hirose BM20B(0.8)-40DS-0.4V(51) | BOM |
| Main chip | RP2040 (QFN-56, 7mm × 7mm) | BOM |
| Flash | W25Q16JVSSIQ (SOIC-8, 5.3×5.3mm) | BOM |
| USB-C port | G-Switch GT-USB-7010ASV | BOM |
| Programmable buttons | SW3 + SW4 (GT-TC018A-H0375-L1) | BOM |

**BB Q20 keyboard footprint (Q20 salvaged from phone):**
- Key matrix area: ~67.5mm × 41.5mm
- FPC ribbon: exits bottom of keyboard, connects to CN1 on BBQ20 PCB

---

## Orange Pi 5B

| Dimension | Value |
|-----------|-------|
| PCB size | 100mm × 62mm |
| SoC | Rockchip RK3588S |
| RAM | 8GB LPDDR4X |
| Storage | 64GB eMMC |
| WiFi | WiFi6 + BT5.0 (onboard) |
| Power input | 5V/4A via Type-C |

### Port Layout (portrait orientation in case)

```
OPi orientation in case: 62mm = width (left↔right), 100mm = height (up↓down)

LEFT SHORT EDGE (62mm) → case LEFT wall:
  • On/Off key          (mid-left, ~30mm from OPi bottom)
  • MIC                 (lower-left, ~10mm from OPi bottom)
  • MaskROM key         (not exposed — internal debug only)

RIGHT SHORT EDGE (62mm) → case RIGHT wall:
  • USB3.0 Type-A       (upper, ~75mm from OPi bottom)
  • USB2.0 Type-A       (just below USB3.0, ~65mm)
  • Gigabit Ethernet    (mid-right, ~45mm from OPi bottom)

BOTTOM LONG EDGE (100mm) → faces case BOTTOM (internal):
  • Type-C/Power (5V/4A) — internal cable to case bottom port
  • WiFi antenna u.FL × 2 — pigtail cables route to case top holes
  • Audio In/Out 3.5mm   — exposed at case bottom edge
  • HDMI OUT             — internal flat cable to screen
  • USB3.0 Type-C        — reserved internal for screen USB-C (touch + power) in v1

TOP LONG EDGE (100mm) → faces case TOP (internal):
  • MicroSD card slot    — exposed through case top edge
  • RECOVERY key         — internal debug, not exposed
  • 26-pin GPIO header   — internal, used for OLEDs
  • Debug TTL UART       — internal
  • LED status light     — small hole in case top face
```

### OPi Mounting Position in Case (CORRECTED — flush right)
- **X position: OPi flush against right wall** — right edge at inner right wall surface
  - Right edge X = 133mm from left inner wall (case inner width 133mm)
  - Left edge X = 133 - 62 = **71mm from left inner wall**
  - Why: USB3.0-A, USB2.0-A, Ethernet on OPi right short edge must poke directly through right wall cutouts. Centered layout made ports unreachable.
- Z offset (bottom margin): (195 - 100) / 2 = **47.5mm top and bottom** ⬆️ from 37.5mm
- Y position (depth): ~15mm from front face (screen ledge at Y=2.5-15mm, OPi behind it)
- Standoffs: 4× M2.5, 3mm tall, 6mm OD, ~3.5mm from each OPi corner (per mounting holes)
- Lifted 3mm off back wall (Y=62mm) for heatsink airflow

> ⚠️ Note: USB2.0 Type-A (right wall) and USB3.0 Type-C (bottom edge) share the same USB controller bus on OPi 5B. Both work simultaneously but at USB2.0 speeds on that bus — fine for keyboard HID and touch controller.

---

## Waveshare 5" IPS HDMI LCD (DSI-TOUCH Model) — ⭐ CURRENT SELECTION

| Dimension | Value | Source |
|-----------|-------|--------|
| Module size (aluminum frame) | 128.00mm × 68.70mm | Outline drawing ✅ |
| PCB board size | **110.40mm × 62.10mm** | Outline drawing ✅ |
| Corner radius (module) | R3.00mm × 4 | Outline drawing |
| Depth (total) | 12.00mm | Outline drawing ✅ |
| PCB thickness | 3.00mm | Outline drawing |
| Active display area | ~122mm × 65mm (estimated) | Spec |
| Resolution | **720 × 1280 (NATIVE PORTRAIT MODE)** ✅ | Spec |
| Interface | **HDMI (full-size) + USB-C (power + touch)** ✅ | Spec + image |
| HDMI port location | Bottom edge of PCB | Verified from image |
| USB-C port location | Top-left of PCB (Power Supply & Touch Port) | Verified from image |
| Touch | 5-point capacitive touch (via USB-C) | Spec |
| Viewing angle | 170° IPS | Spec |
| Brightness | 300 lm | Spec |
| Screen window cutout | 65mm × 115mm | Case design (portrait mount + 0.3mm tolerance) |
| Mounting | 4× corner M2 screws through aluminum frame | Case design |
| Rotation for portrait | **NATIVE — no software rotation needed** ✅ | Hardware native |

**Why this screen is optimal:**
- Native 720×1280 portrait resolution (no rotation overhead)
- HDMI direct compatibility with OPi 5B ✅
- Slightly narrower than alternatives (128mm vs 137mm)
- Aluminum case provides durability + EMI shielding
- 5-point capacitive touch for interactive UI
- No DSI adapter needed (unlike DSI models)

---

## Geekworm Copper Heatsinks

| Size | Quantity | Height |
|------|----------|--------|
| 15mm × 15mm | 2 | 5mm |
| 15mm × 10mm | 2 | 5mm |
| 8mm × 8mm | 2 | 5mm |
| 6mm × 6mm | 2 | 5mm |

- All heatsinks: 5mm tall
- Applied to RK3588S SoC + RAM chips with thermal adhesive tape
- Total heatsink stack height from OPi PCB: 5mm

---

## 0.96" OLED Displays (×5 — 3× yellow-blue, 2× white)

| Dimension | Value | Source |
|-----------|-------|--------|
| OLED panel width | 26.7mm | User measured |
| OLED panel height | 19.3mm | User measured |
| OLED panel thickness | 1.7mm | User measured |
| Module PCB size | 27mm × 27mm (square) | User confirmed |
| PCB thickness | ~0.2mm (very thin) | User measured |
| Mounting holes | 4× M2, one at each PCB corner | User confirmed |
| Mounting method | Double-sided VHB tape (PCB too thin for screws) | Recommended |
| Resolution | 128 × 64 | Spec |
| Interface | I2C, 4 pins: VCC, GND, SCL, SDA | Spec |
| Pin pitch | 2.54mm (standard DuPont) | Spec |
| I2C address | 0x3C (default) | Spec |
| Voltage | 3.3V–5V (OPi GPIO compatible) | Spec |
| Power draw | 0.06W | Spec |

### Wiring (BOTH to OPi GPIO — not BBQ20)
- BBQ20 RP2040 handles keyboard HID only; its I2C pins are not exposed
- OLED1 (upper) → OPi **I2C1** bus (0x3C)
- OLED2 (lower) → OPi **I2C4** bus (0x3C) — separate bus avoids address conflict
- **Connector:** Female-to-female Dupont jumper wires, 4-pin, 2.54mm pitch
  - Do NOT use JST LED strip connectors (wrong pitch, wrong housing, won't fit)
  - Get: "Female to Female Dupont jumper wire 10cm" — $2 on Amazon

### Screen Orientation
- Display works in any orientation — it's hardware-agnostic
- Software rotation: `xrandr --output HDMI-1 --rotate left` on OPi Ubuntu
- Or set `display_rotate=1` in boot config for permanent portrait mode

### Case Cutout Positions (right side wall)
| OLED | Z position | Window size (Y × Z) |
|------|------------|---------------------|
| OLED1 (upper) | Z = 128–148mm | 27.5mm wide × 19.8mm tall |
| OLED2 (lower) | Z = 55–75mm | 27.5mm wide × 19.8mm tall |

- Window cutout = panel + 0.4mm tolerance each axis
- Mounted inside: OLED face pressed against wall opening, PCB held with 4× M2 screws

---

## Anker PowerCore 10000

| Dimension | Value |
|-----------|-------|
| Size | ~95mm × 65mm × 22mm (approximate) |
| Capacity | 10000mAh |
| Output | 5V/3A via USB-A |
| Input | USB-C or micro-USB |
| Use | External power bank, not internal |

> Note: PowerCore is NOT inside the case. It connects externally via
> the case bottom USB-C port when mobile. Case is self-contained otherwise.

---

## Cables (Internal) — CORRECTED CABLE PLAN

| Cable | Length | Route | Notes |
|-------|--------|-------|-------|
| USB-C to USB-C | 13cm | External charger → case bottom cutout → OPi USB-C Power IN | System power |
| **Flat ribbon HDMI** | **~15cm** | **OPi HDMI OUT (bottom edge) → Waveshare HDMI (bottom of PCB)** | **Use flat/FPC HDMI — 2-3mm thin, routes easily inside case** |
| USB-C to USB-C | ~10cm | Waveshare USB-C (top-left of PCB) → OPi USB3.0 Type-C (bottom edge) | Screen power + touch data (one cable handles both!) |
| USB-A to USB-C | ~10cm | BBQ20 PCB USB-C → OPi USB2.0 Type-A (right wall, internal) | Keyboard HID — USB2.0 speed is plenty |
| Dupont 4-pin | 10–15cm | OLED × 2 → OPi GPIO I2C (internal) | Dual OLED displays |

**Port availability result:**
- ✅ USB3.0 Type-A (right wall) — free for external use
- ❌ USB2.0 Type-A (right wall) — taken by BBQ20 keyboard internally
- ✅ Gigabit Ethernet (right wall) — free
- ✅ USB-C Power IN (case bottom) — charger access
- ✅ Audio 3.5mm (case bottom) — free
- ✅ MicroSD (case top) — free
- ❌ USB3.0 Type-C (bottom edge) — taken by screen touch internally
- ❌ HDMI OUT (bottom edge) — taken by screen internally

---

## WiFi Antennas (FPC Sticker Type — VERIFIED)

| Feature | Value | Source |
|---------|-------|--------|
| Antenna type | FPC (Flexible Printed Circuit) sticker | User confirmed |
| Quantity | 2 (one WiFi-only, one WiFi+BT5.0 shared) | OPi 5B spec |
| Patch size | 40mm × 10mm | User confirmed |
| Cable (pigtail) length | 120mm | User confirmed |
| Connector | U.FL (IPEX) | OPi 5B spec |
| Mount location | Inside case walls — fully internal | Design decision |
| Exit holes needed | None — all internal | Confirmed |

### Optimal Placement for Maximum WiFi 6 Signal (MIMO Diversity)
```
Antenna 1 (LEFT wall, VERTICAL polarization):
  • Stick FPC patch vertically in left wall recess
  • Position: Z = 100–140mm (upper section, away from OPi chips)
  • FPC orientation: 40mm tall × 10mm wide

Antenna 2 (BACK PLATE, HORIZONTAL polarization):
  • Stick FPC patch horizontally in back plate recess
  • Position: centered, Z = 120–130mm
  • FPC orientation: 40mm wide × 10mm tall

Result: 90° polarization diversity = maximum MIMO throughput ✓
```

### Why This Placement Works
- 90° angle between patches maximizes spatial MIMO diversity (key for WiFi 6)
- Away from OPi metal heatsinks = less RF shielding
- 120mm cable easily reaches either wall from OPi u.FL connectors
- No holes in case = better structural integrity + cleaner look (transparent PETG)

---

## Case Port Cutout Reference

### LEFT WALL (OPi left short edge)
| Port | Type | Size | Z position |
|------|------|------|------------|
| On/Off power button | Round hole | 8mm dia | ~112mm from bottom |
| MIC | Round hole | 3mm dia | ~58mm from bottom |

### RIGHT WALL (OPi right short edge — ports align directly, OPi flush right)
OPi bottom at Z=47.5mm from case bottom. All port Z = 47.5mm + offset from OPi bottom.

| Port | Type | Size | Z position |
|------|------|------|------------|
| USB3.0 Type-A | Rectangle | 15mm × 8mm | ~123mm from bottom |
| USB2.0 Type-A | Rectangle | 15mm × 8mm | ~113mm from bottom (**internal** — BBQ20 keyboard) |
| Gigabit Ethernet | Rectangle | 17mm × 14mm | ~93mm from bottom |
| SW3 (BBQ20 button) | Round hole | 5mm dia | ~88mm from bottom |
| SW4 (BBQ20 button) | Round hole | 5mm dia | ~76mm from bottom |
| OLED1 window | Rectangle | 27.5mm × 19.8mm | Z=148–168mm |
| OLED2 window | Rectangle | 27.5mm × 19.8mm | Z=60–80mm |

> OPi right edge is flush with right inner wall — ports poke directly through cutouts, no extension cables needed.

### BOTTOM EDGE (OPi bottom long edge via internal cables)
| Port | Type | Size | X position |
|------|------|------|------------|
| Type-C Power In | Rectangle | 10mm × 4mm | ~28mm from left |
| Audio 3.5mm | Round hole | 6.5mm dia | ~43mm from left |

### TOP EDGE (OPi top long edge)
| Port | Type | Size | X position |
|------|------|------|------------|
| WiFi antenna 1 | Round hole | 7mm dia | 22mm from left |
| WiFi antenna 2 | Round hole | 7mm dia | 38mm from left |
| MicroSD slot | Rectangle | 2.5mm × 15mm | ~51mm from left |
| OPi LED window | Round hole | 3mm dia | 66mm from left |

### BACK PLATE
| Feature | Detail |
|---------|--------|
| Ventilation slots | 6× horizontal, 70mm wide × 7mm tall, Z=65–120mm |
| Antenna channels | 2× grooves 8mm wide × 3.5mm deep × 90mm long, from top |
| K!MO vent | Cut-through text, 15mm tall letters, Z≈22–45mm, centered |
| Screw holes | 4× M2.5, corners |

---

## 3D Print Settings

| Setting | Value |
|---------|-------|
| Material | Clear PETG |
| Layer height | 0.2mm |
| Infill | 40% |
| Walls | 3 perimeters |
| Supports | OFF (design is self-supporting) |
| Printer bed | Case body: print standing upright |
| Estimated filament | ~220g body + 30g back plate |

---

## Assembly Order

1. Mount OPi 5B on standoffs with M2.5 × 6mm screws
2. Attach heatsinks to OPi chips with thermal adhesive tape
3. Thread WiFi antenna pigtail cables up through top holes
4. Connect Waveshare screen via internal flat HDMI cable
5. Connect screen USB-C to OPi USB3.0 Type-C (internal short cable for power + touch)
6. Mount screen — set in front window ledge, 4× M2 × 6mm screws
7. Connect OLED displays to OPi GPIO via Dupont wires
8. Snap BBQ20 PCB + Q20 keyboard into keyboard cavity guide rails
9. Connect BBQ20 USB-C → OPi USB-A (keyboard HID cable)
10. Route all cables neatly, close back plate with 4× M2.5 screws

---

## OPi 5B Precise Port Positions (VERIFIED)

All coordinates in OPi landscape board system (origin = bottom-left corner).
Board: 100mm wide (X) × 62mm tall (Y).

| Feature | X (from left) | Y (from bottom) | Hole Size | Notes |
|---------|--------------|-----------------|-----------|-------|
| On/Off Key | 95.5mm | 59.5mm (2.5mm from top) | Ø3.5mm | Button stands 1.5mm above PCB |
| MIC | 51.2mm | 3.8mm (from bottom) | Ø2.0mm | Near 3.5mm audio jack |
| Mounting hole TL | 3.5mm | 58.5mm | Ø3.0mm | M2.5 |
| Mounting hole TR | 96.5mm | 58.5mm | Ø3.0mm | M2.5 |
| Mounting hole BL | 3.5mm | 3.5mm | Ø3.0mm | M2.5 |
| Mounting hole BR | 96.5mm | 3.5mm | Ø3.0mm | M2.5 |

### Power Button Design Decision
The On/Off key is a **surface-mount button on the PCB** (not on a board edge).
It cannot be accessed through a case wall directly.

**Solution: External momentary switch** (professional, no hacks needed):
1. Solder 2 thin wires to OPi On/Off key solder pads (or test points)
2. Route wires to a standard 6mm momentary tactile switch
3. Switch snaps into 7mm hole on LEFT wall at Z≈112mm from case bottom
4. Press button to power on/off — just like any laptop power button

Get: "6mm momentary tactile switch with cap, through-hole" — $3 for 10pcs on Amazon

## Case Material

| Setting | Value |
|---------|-------|
| Material | **Clear PETG** (transparent) |
| Layer height | 0.2mm |
| Infill | 40% |
| Walls | 3 perimeters |
| Supports | OFF |
| Temperature | ~230°C nozzle, 80°C bed (PETG typical) |
| Print orientation | Standing upright (portrait) |

Why Clear PETG over PLA:
- Transparent for component visibility + glowing OLEDs
- More flex = better snap clips and port tolerance
- Better heat resistance (OPi can get warm)
- K!MO vent signature glows with any internal LED light

## All Measurements Collected ✓

Geometry baseline is captured and synchronized with PROJECT_STATUS.md.
Final cutout lock still depends on post-arrival dry-fit with BBQ20 PCB and real cable routing.
Recommended flow: cardboard fit test first, then PETG print.
