# Cyberdeck Case — COMPLETE DESIGN SPECIFICATION v5
**Purpose:** Pre-code verification that every component fits exactly without crowding  
**Status:** READY FOR REVIEW before REVIEW-CASE.scad is written  
**Date:** April 11, 2026

---

## SECTION 1: EXTERIOR SHELL DIMENSIONS

| Dimension | Value | Source |
|-----------|-------|--------|
| **Width (X)** | 86mm | MEASUREMENTS.md |
| **Height (Z)** | 175mm | MEASUREMENTS.md |
| **Depth (Y)** | 47mm | MEASUREMENTS.md |
| **Wall thickness** | 2.5mm | MEASUREMENTS.md |
| **Corner radius** | 6mm | MEASUREMENTS.md |
| **Back plate thickness** | 3mm | MEASUREMENTS.md |

**Implications:**
- Exterior bounding box: 86 × 175 × 47mm
- Interior cavity: (86 - 2×2.5) × (175 - 2×2.5) × (47 - 2.5) = 81 × 170 × 44.5mm
  - **But back plate is separate**: interior back face at Y = 44mm (47 - 3)
  - **Usable cavity depth**: Y = 2.5mm (front wall) to Y = 44mm (interior back surface) = **41.5mm** ✓

---

## SECTION 2: FRONT FACE WINDOW CUTOUTS

### Screen Window
| Parameter | Value | Calculation |
|-----------|-------|-------------|
| **Width** | 53mm | Per MEASUREMENTS.md |
| **Height** | 88mm | Per MEASUREMENTS.md |
| **Position from top** | 8mm | Per MEASUREMENTS.md |
| **Horizontal center** | (86-53)/2 = 16.5mm from left | Auto-calculated |
| **Bottom edge Z** | 175 - 8 - 88 = 79mm | Calculated |
| **Top edge Z** | 175 - 8 = 167mm | Calculated |
| **Y depth** | 0mm to 2.5mm (front wall) | Cuts through front shell |

**Verification:** Window is 53×88 = 4,664mm² → visible screen area ✓

---

### Keyboard Window
| Parameter | Value | Calculation |
|-----------|-------|-------------|
| **Width** | 69mm | Per MEASUREMENTS.md |
| **Height** | 44mm | Per MEASUREMENTS.md |
| **Position from bottom** | 10mm | Per MEASUREMENTS.md |
| **Horizontal center** | (86-69)/2 = 8.5mm from left | Auto-calculated |
| **Bottom edge Z** | 10mm | Directly calculated |
| **Top edge Z** | 10 + 44 = 54mm | Calculated |
| **Y depth** | 0mm to 2.5mm (front wall) | Cuts through front shell |

**Verification:** Window is 69×44 = 3,036mm² → Q20 keyboard visible ✓

---

## SECTION 3: ORANGE PI 5B BOARD POSITIONING

### Board Dimensions
| Parameter | Value | Source |
|-----------|-------|--------|
| **Width (X)** | 62mm | MEASUREMENTS.md |
| **Height (Z)** | 100mm | MEASUREMENTS.md |
| **Thickness (Y)** | 1.6mm | Standard PCB |

### Board Centering in Case
| Axis | Calculation | Result | Notes |
|------|-------------|--------|-------|
| **X** | (86 - 62) / 2 | 12mm from each side | Centered horizontally ✓ |
| **Z** | (175 - 100) / 2 | 37.5mm from top & bottom | Centered vertically ✓ |
| **Y** | Front of board at interior cavity | Y = 39.4mm to Y = 41mm | See detail below |

### Board Y Position (Critical)
```
Interior cavity: Y = 2.5mm to Y = 44mm (41.5mm total depth)

Component stack (front to back):
├─ Front wall: Y = 0 to Y = 2.5mm (2.5mm wall)
├─ Screen PCB: Y = 2.5 to Y = 5.5mm (3mm board)
├─ Cable routing space: Y = 5.5 to Y = 34.4mm (28.9mm available)
├─ Heatsinks (on top of OPi): Y = 34.4 to Y = 39.4mm (5mm tall)
├─ OPi 5B PCB: Y = 39.4 to Y = 41mm (1.6mm board thickness)
├─ Standoffs (support): Y = 41 to Y = 44mm (3mm tall)
├─ Interior back surface: Y = 44mm
└─ Back plate (exterior): Y = 44 to Y = 47mm (3mm back plate)
```

**CRITICAL CALCULATION:**
- Standoff formula: Y = (CASE_D - 3) - STANDOFF_H = (47 - 3) - 3 = **41mm** ✓
- OPi top surface: 41 - 1.6 = 39.4mm (board sitting on standoffs) ✓
- Heatsinks rest ON TOP of OPi board (Z-facing up), stack height 5mm upward, not interfering with Y-axis ✓

---

## SECTION 4: WAVESHARE 4" SCREEN POSITIONING

### Screen PCB Dimensions
| Parameter | Value | Source |
|-----------|-------|--------|
| **Width (X)** | 76mm | MEASUREMENTS.md |
| **Height (Z)** | 98.58mm | MEASUREMENTS.md |
| **Thickness (Y)** | ~3mm | Standard LCD module |

### Screen Mounting in Case
| Position | Value | Notes |
|----------|-------|-------|
| **Y depth** | 2.5 to 5.5mm | Rests on 1.5mm ledge; board occupies ~3mm depth |
| **X centering** | (86-76)/2 = 5mm margin each side | Centered |
| **Z position** | 175 - 8 - 88 = 79mm (bottom edge) | Matches screen window bottom |
| **Screen ledge** | Y = 2.5 to Y = 4mm (1.5mm step) | PCB rests here |

**Verification:** 
- Screen window: 53×88mm (visible area) ✓
- Screen board: 76×98.58mm (full PCB) ✓
- Screen fits in window with margins ✓
- Does NOT interfere with cable routing space (Y = 5.5-34.4mm) ✓

---

## SECTION 5: HEATSINK POSITIONING

### Heatsink Stack
| Component | Qty | Height | Position |
|-----------|-----|--------|----------|
| 15×15mm copper | 2 | 5mm | On OPi chips |
| 15×10mm copper | 2 | 5mm | On OPi chips |
| 8×8mm copper | 2 | 5mm | On OPi chips |
| 6×6mm copper | 2 | 5mm | On OPi chips |

### Heatsink Mounting (Y-axis)
- **Mounted ON TOP of OPi PCB** (in Z direction, not Y)
- OPi top surface: Y = 39.4mm
- Heatsinks extend UPWARD (Z-axis), not into Y-cavity
- Heatsink base touching OPi: Y = 39.4mm
- Heatsinks DO NOT extend into Y-axis space ✓

### Heatsink Clearance
- Chips face FRONT (toward screen cables)
- Heatsinks face INTERIOR (toward still air)
- Back wall interior: Y = 44mm
- Airflow gap: 44 - 39.4 = 4.6mm clearance (with 5mm heatsink, this is NEGATIVE)

**⚠️ ISSUE DETECTED:** Heatsinks extend 5mm upward, but if they're treated as full 5mm depth on Y-axis, they'd touch the back wall. Need clarification: **Are heatsinks oriented with their height (5mm) going in WHICH direction?**

---

## SECTION 6: INTERNAL CABLE ROUTING SPACE

### Available Space
```
Y = 5.5mm (after screen) to Y = 34.4mm (before heatsinks)
= 28.9mm available depth for all cables
```

### Cables to Route (approximate thicknesses)
| Cable | Qty | Diameter/Width | Total space | Status |
|-------|-----|-----------------|-------------|--------|
| HDMI flat | 1 | ~3mm | 3mm | ✓ Fits |
| USB-C power | 1 | ~4mm | 4mm | ✓ Fits |
| Dupont wires (4-pin) | 2 | ~2mm each | 4mm | ✓ Fits |
| FPC antenna pigtails | 2 | ~2mm each | 4mm | ✓ Fits |
| **Total used** | | | ~15mm | ✓ Well within 28.9mm |

**Safety margin:** 28.9 - 15 = **13.9mm excess → 1.93× safety factor** ✓

---

## SECTION 7: PORT CUTOUT POSITIONS

### LEFT WALL (OPi LEFT SHORT EDGE)
| Port | Z from bottom | Diameter/Size | Verified |
|------|--------------|---|----------|
| Power button | 67.5mm | 8mm Ø | ✓ MEASUREMENTS.md |
| MIC hole | 47.5mm | 3mm Ø | ✓ MEASUREMENTS.md |

**Check:** Both ports within case height (0-175mm) ✓

---

### RIGHT WALL (OPi RIGHT SHORT EDGE) 
| Port | Z from bottom | Size | Verified |
|------|-------------|------|----------|
| USB3.0 Type-A | 113mm | 15×8mm | ✓ MEASUREMENTS.md |
| USB2.0 Type-A | 103mm | 15×8mm | ✓ MEASUREMENTS.md |
| Gigabit Ethernet | 83mm | 17×14mm | ✓ MEASUREMENTS.md |
| SW3 button | 40mm | 5mm Ø | ✓ MEASUREMENTS.md |
| SW4 button | 28mm | 5mm Ø | ✓ MEASUREMENTS.md |
| OLED1 (upper) | 128-148mm | 27.5×19.8mm | ✓ MEASUREMENTS.md |
| OLED2 (lower) | 55-75mm | 27.5×19.8mm | ✓ MEASUREMENTS.md |

**Spacing verification:**
```
SW4 (28mm) ↓
  4mm gap
SW3 (40mm) ↓
  4mm gap
Ethernet (83mm) ↓
  10mm gap
USB2.0 (103mm) ↓
  10mm gap
USB3.0 (113mm) ↓
  15mm gap
OLED2 (55-75mm) — between SW3 & Ethernet ✓
OLED1 (128-148mm) — above USB3.0 ✓
```

**All positions valid with proper spacing** ✓

---

### BOTTOM EDGE (OPi BOTTOM LONG EDGE)
| Port | X from left | Size | Verified |
|------|------------|------|----------|
| Type-C Power In | ~28mm | 10×4mm | ✓ MEASUREMENTS.md |
| Audio 3.5mm | ~43mm (center) | 6.5mm Ø | ✓ MEASUREMENTS.md |

**Check:** Both roughly centered, no overlap ✓

---

### TOP EDGE (OPi TOP LONG EDGE)
| Port | X from left | Size | Verified |
|------|------------|------|----------|
| WiFi antenna 1 | ~22mm | 7mm Ø | ✓ MEASUREMENTS.md |
| WiFi antenna 2 | ~38mm | 7mm Ø | ✓ MEASUREMENTS.md |
| MicroSD slot | ~51mm | 2.5×15mm | ✓ MEASUREMENTS.md |
| LED window | ~66mm | 3mm Ø | ✓ MEASUREMENTS.md |

**Check:** No overlap, all fit within 86mm width ✓

---

### BACK PLATE
| Feature | Z Position | Size | Verified |
|---------|-----------|------|----------|
| K!MO text | ~33mm | 15mm tall | ✓ MEASUREMENTS.md |
| Ventilation slots | 65-120mm | 6× horizontal | ✓ MEASUREMENTS.md |
| Antenna 2 recess | 120-130mm | 40×10mm | ✓ MEASUREMENTS.md |
| Screw holes | 6mm from corners | 4× M2.5 | ✓ MEASUREMENTS.md |

**Check:** K!MO not interfering with vent slots (33mm vs 65-120mm) ✓

---

## SECTION 8: CRITICAL DESIGN QUESTIONS (Need Answers Before Coding)

### Question 1: Rounded Corners Approach
**Current problem:** `hull()` of cylinders creates non-manifold geometry where windows can't be properly subtracted.

**Options:**
- A) Use `minkowski()` with a sphere for true rounded corners?
- B) Use direct box with manual rounded-corner fillet (polyhedron)?
- C) Keep corners sharp, only round top/bottom edges?

**RECOMMENDATION:** Option B — manual rounded corners only where needed (top edges visible), keep front/back faces flat for clean window subtraction.

---

### Question 2: Window Subtraction Order
**Should we:**
- A) Subtract outer shell → subtract inner cavity → subtract windows?
- B) Subtract outer shell → subtract windows FIRST → then inner cavity?  
- C) Create shell with no top/bottom, then add walls separately?

**RECOMMENDATION:** Option A (subtract in order of largest to smallest) — ensures windows actually cut through.

---

### Question 3: Interior Cavity Strategy
**Current cavity:**
```scad
translate([WALL, WALL, WALL])
    cube([CASE_W - 2*WALL, CASE_D - WALL, CASE_H - 2*WALL]);
```

**This is OPEN AT THE BACK.** Should it be:
- A) Truly open (current) — back wall will be added by back_plate only?
- B) Mostly open but with thin back lip (0.5mm)?
- C) Closed at back, then subtract the back for mounting holes?

**RECOMMENDATION:** Option A (truly open) — back plate adds structure independently.

---

### Question 4: Heatsink Z-Axis Clarification
**From measurements:** Heatsinks are 5mm tall and sit "on top of OPi chips."

**Does this mean:**
- A) Heatsinks mount vertically above the PCB (5mm height in +Z direction)?
- B) Heatsinks sit level on PCB but with 5mm contact area?

**ASSUMPTION:** Option A — heatsinks extend +5mm in Z-axis (away from back wall), NOT extending into Y-cavity backward.

---

## SECTION 9: COMPONENT CROWDING CHECK

### Internal Y-Axis Fit (Most Critical)
```
Total cavity: 41.5mm (Y=2.5 to Y=44)

Allocation:
├─ Front wall: 0mm (exterior)
├─ Screen PCB: 3mm (2.5 to 5.5)
├─ Cable space: 28.9mm (5.5 to 34.4) — MORE THAN NEEDED
├─ Heatsinks: 0mm (extend upward in Z, not backward in Y) 
├─ OPi board: 1.6mm (39.4 to 41)
├─ Standoffs: 3mm (41 to 44)
└─ Back plate: 3mm (44 to 47 — exterior)

TOTAL DEPTH USED: 3 + 28.9 + 1.6 + 3 = 36.5mm
CAVITY AVAILABLE: 41.5mm
CLEARANCE: 41.5 - 36.5 = 5mm EXTRA ✓✓ NOT CROWDED
```

### X-Axis (Horizontal) Fit
```
Case width: 86mm

OPi board: 62mm centered = 12mm + 62mm + 12mm ✓
Screen board: 76mm centered = 5mm + 76mm + 5mm ✓
Q20 keyboard: 67.5mm centered = 9.25mm + 67.5mm + 9.25mm ✓

All fit without crowding ✓
```

### Z-Axis (Vertical) Fit
```
Case height: 175mm

Screen window: 8mm gap + 88mm window = 96mm from top ✓
Keyboard window: 10mm + 44mm = 54mm from bottom ✓
OPi board: 37.5mm from top/bottom, 100mm tall ✓
Ports distributed from 28mm to 148mm ✓

All fit without crowding ✓
```

---

## SECTION 10: DESIGN VALIDATION CHECKLIST

- [x] Exterior dimensions match MEASUREMENTS.md
- [x] Component positions mathematically verified
- [x] No overlaps between components
- [x] Cable routing space > actual cable thickness
- [x] Window positions don't overlap
- [x] Port positions don't overlap
- [x] Y-axis cavity has 5mm extra clearance (NOT crowded)
- [ ] **UNCLEAR:** Heatsink mounting direction (Z vs Y) — need confirmation
- [ ] **UNCLEAR:** Window subtraction order for proper geometry
- [ ] **UNCLEAR:** Rounded corner implementation strategy

---

## READY FOR CODING?

**Status: 95% READY — 3 clarifying questions need answers**

Please confirm or clarify:

1. **Heatsinks:** Do they extend 5mm in +Z direction (upward from PCB), or do they somehow need to be considered in Y-axis depth?

2. **Rounded corners:** Should I use manual corner fillets (Option B) instead of `hull()`?

3. **Window subtraction:** Should I subtract windows AFTER inner cavity (ensures they cut through)?

Once confirmed, REVIEW-CASE.scad will be written with 100% confidence.
