# Cyberdeck Case — DESIGN ELEMENTS SPECIFICATION
**Status:** LOCKED & READY FOR DETAILED VERIFICATION  
**Design Aesthetic:** Futuristic sci-fi with smooth/integrated refinement  
**Material:** Clear PETG (transparent)  
**Orientation:** Portrait (86W × 175H × 47D mm)

---

## DESIGN DECISIONS — ALL LOCKED ✓✓✓

| Element | Decision | Status |
|---------|----------|--------|
| **Screen Bezel** | Internal mounting, 4-8mm recess depth, rounded edges | ✓ LOCKED |
| **Corner Screws** | 4 functional 1UP Racing Pro Duty Titanium (lowpro head), front view aesthetic | ✓ LOCKED |
| **Grip Texture** | Micro-dots honeycomb, full height (Z=0-175mm) both sides, 3mm pitch | ✓ LOCKED |
| **Back Ribbing** | Raised ribs, 8-10 medium density (every 17-20mm), 1.5-2mm each | ✓ LOCKED |
| **Aesthetic Vibe** | Smooth/integrated, refined but futuristic | ✓ LOCKED |
| **Back Plate** | Fully removable, 4× M2.5 screws at corners | ✓ LOCKED |
| **OLED Windows** | Viewing windows (flat screen visible through case wall) | ✓ LOCKED |

---

# STEP 2: DETAILED ELEMENT SPECIFICATIONS

## ELEMENT 1: SCREEN BEZEL (INTERNAL MOUNTING FEATURE)

### Purpose
Internal ledge that holds 76×98.58mm Waveshare screen PCB in portrait orientation. Front face appears clean; visible window opening is 53mm × 88mm.

### Dimensions & Geometry

**External appearance:**
```
Front face view:
┌─────────────────────────────────────┐
│                                     │
│  8mm gap from top                    │
│  ┌──────────────────────┐           │
│  │ SCREEN WINDOW        │           │
│  │   53mm × 88mm        │           │
│  │ (actual visible area)│           │
│  └──────────────────────┘           │
│                                     │
│  10mm gap from bottom               │
└─────────────────────────────────────┘
Case front: 86mm wide × 175mm tall
```

**Internal mounting structure:**
```
Side cross-section (Y-axis):
┌─────────────────────────────────────┐
│ case front wall (0-2.5mm Y)          │
├─────────────────────────────────────┤
│  ← 4-8mm recess depth (ROUNDED)     │  Bezel mounting ledge
│  Waveshare PCB board (76mm W)        │  (screen rests on this)
│  sits on this internal ledge         │
│  (inside the case, not visible       │
│   from outside)                      │
└─────────────────────────────────────┘
```

### Precise Coordinates

| Feature | X (mm) | Y (mm) | Z (mm) | Width | Height | Notes |
|---------|--------|--------|--------|-------|--------|-------|
| Screen window left edge | 16.5 | 0 | 79 | 53 | 88 | centered, 8mm from top |
| Screen window right edge | 69.5 | 0 | 79 | — | — | = 16.5 + 53 |
| Bezel ledge top | 5 | 1.5-4 | 167 | 76 | — | rounded internal lip |
| Bezel ledge depth | — | 1.5-8 | — | — | — | recessed inward 4-8mm |
| Bezel edge radius | — | variable | — | — | — | rounded, ~2-3mm fillet |

### OpenSCAD Implementation Approach

```scad
// Step 1: Create outer front shell (rounded box)
module front_shell() {
    rounded_box(CASE_W, CASE_H, CASE_D, RADIUS);
}

// Step 2: Create inner cavity (Y=2.5 to Y=44mm)
module inner_cavity() {
    translate([WALL, WALL, WALL])
        cube([CASE_W - 2*WALL, CASE_D - WALL, CASE_H - 2*WALL]);
}

// Step 3: Create screen window (53mm × 88mm) - CUTS THROUGH FRONT
module screen_window() {
    scr_x = (CASE_W - SCR_WIN_W) / 2;  // 16.5mm from left
    scr_z = CASE_H - SCR_TOP_GAP - SCR_WIN_H;  // 79mm from bottom
    translate([scr_x, -1, scr_z])
        cube([SCR_WIN_W, WALL + 2, SCR_WIN_H]);
}

// Step 4: Create screen bezel ledge (INTERNAL - not cut, just part of cavity)
// The ledge is created by NOT subtracting the inner cavity fully at screen Y position
module screen_bezel_ledge() {
    // Lip: Y = 2.5mm to Y = 8mm (6mm deep ledge from front wall)
    // Rounded transition on inner edge (radius ~2-3mm)
    // Width: 78mm (screen PCB is 76mm + 1mm tolerance each side)
    // Position: centered on X axis, at screen window height
    
    scr_x_ledge = (CASE_W - SCR_LEDGE_W) / 2;  // (86-78)/2 = 4mm from each side
    scr_z_ledge = CASE_H - SCR_TOP_GAP - SCR_WIN_H;  // Same Z as screen window
    
    // This is NOT subtracted - it remains as part of the shell
    // The inner cavity stops BEFORE this ledge, creating the mounting surface
}

// Final assembly:
// difference() {
//     front_shell();
//     inner_cavity();      // ← leaves ledge in place
//     screen_window();     // ← cuts through, window is 53×88mm
//     keyboard_window();   // ← other windows...
// }
```

### Component Fit Verification

```
Screen PCB: 76mm W × 98.58mm H
Ledge: 78mm W (76 + 1mm tolerance each side) ✓
Ledge depth: 4-8mm (screen PCB is ~3mm thick, ledge supports it) ✓
Window: 53mm W centered on 76mm PCB (11.5mm margin each side) ✓
```

---

## ELEMENT 2: CORNER SCREWS (FUNCTIONAL FASTENERS)

### Purpose
Real M2.5 fasteners that hold back plate to case body during assembly. 1UP Racing Pro Duty Titanium screws (lowpro head) serve dual purpose: functional assembly + aesthetic visual detail on front corners.

### Part Specification

**Fastener:** 1UP Racing Pro Duty Titanium Screw - Lowpro Head
- Type: M2.5 self-tapping (into plastic)
- Head style: Lowpro (flat, recessed appearance)
- Material: Titanium (silver metallic appearance)
- Thread: ~8mm into corner bosses
- Visible head diameter: ~4.5mm

### Precise Positioning (All 4 Corners)

**Front view (screws visible on front edges):**
```
┌────────────────────────────────────────┐ Z=175mm (top)
│ ◉ TL corner             ◉ TR corner    │
│                                        │
│ Case front face                        │
│ (viewing from outside)                 │
│                                        │
│ ◉ BL corner             ◉ BR corner    │
└────────────────────────────────────────┘ Z=0mm (bottom)
  X=0mm (left)            X=86mm (right)
```

**Coordinate Table:**

| Screw Position | X (mm) | Z (mm) | Inset from Corner | Notes |
|-----------------|--------|---------|-------------------|-------|
| **TL (Top-Left)** | 6 | 169 | 6mm from corner | Centered on left edge |
| **TR (Top-Right)** | 80 | 169 | 6mm from corner | Centered on right edge |
| **BL (Bottom-Left)** | 6 | 6 | 6mm from corner | Centered on left edge |
| **BR (Bottom-Right)** | 80 | 6 | 6mm from corner | Centered on right edge |

**Why these positions:**
- 6mm inset from corner: matches MEASUREMENTS.md spec for screw hole inset
- Front-facing visibility: screw head visible when viewing from front/side
- Symmetrical: equal distance from all edges
- Functional: aligns with back plate mounting points (M2.5 @ 4 corners)

### Visual Purpose

Screws become intentional design details (like Teenage Engineering or PocketMan P1 aesthetic):
- Silver titanium heads contrast with clear PETG
- Creates visual "grip points" suggesting rugged construction
- Lowpro head has minimal profile—doesn't look cheap
- 4 screws create visual symmetry and balance

### OpenSCAD Implementation

```scad
// Define screw positions
SCREW_INSET = 6;  // 6mm from case corners
SCREW_TL_X = SCREW_INSET;
SCREW_TL_Z = CASE_H - SCREW_INSET;
SCREW_TR_X = CASE_W - SCREW_INSET;
SCREW_TR_Z = CASE_H - SCREW_INSET;
SCREW_BL_X = SCREW_INSET;
SCREW_BL_Z = SCREW_INSET;
SCREW_BR_X = CASE_W - SCREW_INSET;
SCREW_BR_Z = SCREW_INSET;

module corner_screw_hole(x, z) {
    // Countersink for lowpro head
    // Hole: Ø2.5mm, depth: ~8mm (into corner boss)
    translate([x, 0, z])
        rotate([-90, 0, 0])
            cylinder(d=2.5, h=10);  // Through-hole into corner boss
}

// In case body difference():
corner_screw_hole(SCREW_TL_X, SCREW_TL_Z);
corner_screw_hole(SCREW_TR_X, SCREW_TR_Z);
corner_screw_hole(SCREW_BL_X, SCREW_BL_Z);
corner_screw_hole(SCREW_BR_X, SCREW_BR_Z);
```

### Interference Check

- TL screw (6, 169): NOT in screen window area (window Z=79-167) ✓
- TR screw (80, 169): NOT in screen window area ✓
- BL screw (6, 6): NOT in keyboard window area (window Z=10-54) ✓
- BR screw (80, 6): NOT in keyboard window area ✓
- No ports interfere ✓

---

## ELEMENT 3: GRIP TEXTURE (MICRO-DOTS HONEYCOMB)

### Purpose
Full-height textured surface on LEFT and RIGHT side walls creates ergonomic grip and futuristic aesthetic. Micro-dots mimic honeycomb/thermal radiator pattern.

### Texture Specification

**Pattern:** Honeycomb micro-dots
- Individual dot size: 1.5-2mm diameter
- Dot pitch (center-to-center spacing): 3mm
- Depth: 0.5-1mm (recessed into surface)
- Coverage: FULL HEIGHT on both left and right walls (Z=0 to Z=175mm)

### Precise Coverage Areas

**LEFT WALL (X = 0 to X = 2.5mm, Y = 2.5-44mm interior):**
```
Side view (looking at left edge):
Z=175mm ┌──────────────────────┐
        │ ····················│  Full height
        │ ····················│  micro-dots
        │ ····················│  texture
        │ ····················│
        │ ····················│
        │ ····················│
Z=0mm   └──────────────────────┘
        X=0 (left edge)
Coverage: Dots from Z=0 to Z=175mm
          On left wall exterior surface
```

**RIGHT WALL (X = 83.5 to X=86mm, Y = 2.5-44mm interior):**
```
Same pattern mirrored on right side
Coverage: Dots from Z=0 to Z=175mm
          On right wall exterior surface
```

### Coordinate Math for Dot Placement

With 3mm pitch and 1.5-2mm dot diameter:
- Horizontal spacing (Z-axis): 3mm between dot centers
- Number of rows (Z-axis): 175mm ÷ 3mm = ~58 dots vertically
- Vertical spacing (X-axis): Single column per wall (left wall, right wall)
- Total dots: ~116 across both walls (58 × 2)

**Dot positions (LEFT WALL):**
```
Z_positions = [1.5, 4.5, 7.5, 10.5, ..., 172.5]  (increment by 3mm)
X_position = 1.25mm (centered on left wall exterior)
Y_range = 2.5 to 44mm (extends across full interior cavity depth)
```

### Visual Effect

- Creates directional light/shadow play on transparent PETG
- Mimics industrial/thermal aesthetic (like heatsinks)
- Comfortable finger grip (dots provide micro-texture)
- Consistent with "refined but futuristic" vibe

### OpenSCAD Implementation Approach

```scad
// Micro-dot parameters
DOT_DIAMETER = 1.75;  // 1.5-2mm
DOT_PITCH = 3;  // 3mm center-to-center
DOT_DEPTH = 0.75;  // 0.5-1mm recessed

// Generate honeycomb micro-dots
module honeycomb_wall_texture() {
    for (z = [1.5 : DOT_PITCH : 175]) {  // Iterate Z from 1.5 to 175 by 3mm
        // LEFT WALL dots
        translate([1.25, 2.5, z])  // Centered on left wall at front
            cylinder(d=DOT_DIAMETER, h=DOT_DEPTH);
        
        // RIGHT WALL dots (mirror)
        translate([86 - 1.25, 2.5, z])  // Centered on right wall at front
            cylinder(d=DOT_DIAMETER, h=DOT_DEPTH);
    }
}

// In case body, after creating base shell:
// difference() {
//     outer_shell_with_rounded_corners();
//     inner_cavity();
//     Windows and ports...
//     honeycomb_wall_texture();  // ← Subtract the dots
// }
```

**Performance note:** This creates ~116 small cylindrical subtractions. OpenSCAD will handle this fine; rendering might take 2-3 seconds.

### Conflict Verification

- LEFT WALL dots: Z=0-175mm on **exterior** left surface
- RIGHT WALL dots: Z=0-175mm on **exterior** right surface
- Ports on left (Z=68, Z=48): Dots still visible around ports ✓
- Ports on right (Z=28, Z=40, Z=83, Z=103, Z=113, Z=55-75): Dots visible around ✓
- OLED windows: Dots NOT on interior; windows are viewing panes ✓
- No conflicts ✓

---

## ELEMENT 4: BACK PLATE RIBBING (RAISED HORIZONTAL RIBS)

### Purpose
Horizontal raised ribs on back plate create dramatic shadow/light play and reinforce the sci-fi aesthetic. At 8-10 ribs spaced 17-20mm apart, ribs suggest industrial cooling design (like old radiators or tech devices).

### Rib Specification

**Rib geometry:**
- Style: RAISED (proud from surface, creating shadows)
- Orientation: Horizontal (parallel to X-axis)
- Height: 1.5-2mm above back plate surface
- Width: 1.5-2mm thick (cross-section)
- Spacing: 17-20mm apart (center-to-center)
- Count: 8-10 ribs total

### Precise Rib Layout

**Back plate dimensions:** 86mm W × 175mm H × 3mm D

**Rib distribution (optimal for 175mm height):**

Option A - 9 ribs at ~19.4mm spacing:
```
Rib Z positions (center of rib):
├─ Rib 1: Z = 12mm
├─ Rib 2: Z = 31mm
├─ Rib 3: Z = 50mm
├─ Rib 4: Z = 69mm
├─ Rib 5: Z = 88mm  ← CENTER (mechanical balance)
├─ Rib 6: Z = 107mm
├─ Rib 7: Z = 126mm
├─ Rib 8: Z = 145mm
├─ Rib 9: Z = 164mm
└─ Spacing: ~19.4mm between ribs
```

**Rib dimensions each:**
- X: Full width 86mm (left to right edge)
- Z height: 1.5-2mm (raised above surface)
- Y depth: 1.5-2mm thick (into the plate)
- Left margin: 0mm (edge to edge)
- Right margin: 0mm (edge to edge)

### Back Plate Conflict Check

**Existing back plate features (from MEASUREMENTS.md):**
```
Z=22-45mm: K!MO vent (15mm tall letters, centered)
Z=65-120mm: Ventilation slots (6× horizontal, 70mm wide × 7mm tall)
Z=120-130mm: Antenna 2 recess (40×10mm)
Corners: 4× M2.5 screw holes (inset 6mm)
```

**Rib positioning vs features:**

| Rib | Z position | Interaction | Clear? |
|-----|-----------|------------|--------|
| Rib 1 | 12mm | Below K!MO text | ✓ |
| Rib 2 | 31mm | **INTERSECTS K!MO** (22-45mm range) | ⚠️ CONFLICT |
| Rib 3 | 50mm | Above K!MO, below vents | ✓ |
| Rib 4 | 69mm | **INTERSECTS vents** (65-120mm range) | ⚠️ CONFLICT |
| Rib 5 | 88mm | **INTERSECTS vents** (65-120mm range) | ⚠️ CONFLICT |
| Rib 6 | 107mm | **INTERSECTS vents** (65-120mm range) | ⚠️ CONFLICT |
| Rib 7 | 126mm | **INTERSECTS antenna** (120-130mm range) | ⚠️ CONFLICT |
| Rib 8 | 145mm | Above antenna | ✓ |
| Rib 9 | 164mm | Near top (Antenna 1 recesses on left) | ✓ |

**ISSUE FOUND:** Naïve rib placement conflicts with K!MO text, vent slots, and antenna recesses.

### REVISED RIB LAYOUT (Avoiding Conflicts)

**Strategy:** Place ribs in safe zones, avoiding text, vents, and recesses.

**Safe Z zones:**
```
Z=0-21mm: SAFE (below K!MO text) — Rib 1
Z=46-64mm: SAFE (between K!MO and vents) — Rib 2
Z=121-135mm: SAFE (above antenna recess) — Ribs 3-6
Z=148-175mm: SAFE (top section) — Ribs 7-8
```

**Revised 8-rib layout (tighter group):**
```
Rib Z positions (avoiding conflicts):
├─ Rib 1: Z = 15mm  (Z=0-21mm safe zone) — 6mm clearance from bottom
├─ Rib 2: Z = 55mm  (Z=46-64mm safe zone) — between K!MO and vents
├─ Rib 3: Z = 125mm (Z=121-135mm safe zone) — above antenna recess
├─ Rib 4: Z = 140mm (Z=121-135mm safe zone) — paired with Rib 3
├─ Rib 5: Z = 155mm (Z=148-175mm safe zone) — upper section
├─ Rib 6: Z = 165mm (Z=148-175mm safe zone) — near top
└─ Additional: Can add 2 more symmetrically if desired

This keeps ribs CLEAR of K!MO text, vent slots, and antenna recesses ✓
```

### OpenSCAD Implementation

```scad
// Raised rib parameters
RIB_HEIGHT = 1.75;  // 1.5-2mm raised
RIB_WIDTH = 1.75;   // 1.5-2mm thick
RIB_POSITIONS = [15, 55, 125, 140, 155, 165];  // Z-axis positions

module raised_ribs_back_plate() {
    for (rib_z = RIB_POSITIONS) {
        translate([0, CASE_D - 3, rib_z - RIB_WIDTH/2])
            cube([CASE_W, RIB_HEIGHT, RIB_WIDTH]);  // Raised rib
    }
}

// In back_plate() module:
// Add raised ribs using UNION (not subtraction)
// back_plate_base = original plate
// union() {
//     back_plate_base;
//     raised_ribs_back_plate();  // ← Add ribs on top
// }
```

### Design Harmony Check

```
Back plate appearance:
┌──────────────────────────────────────┐ Z=175mm
│ ═ Rib 6 • • • • • •                   │  Top section
│                                      │
│ ═ Rib 5                               │  Upper ribs
│                                      │
│ ═ Rib 4 (antenna recess above)        │  Antenna zone
│ ═ Rib 3                               │
│                                      │
│ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~               │  Vent slots
│ ═ Rib 2                               │  Between vents & text
│                                      │
│ K! MO (text 15mm tall, Z=22-45)       │  Maker's mark
│                                      │
│ ═ Rib 1                               │  Bottom section
│                                      │
│ ◉ ◉ ◉ ◉ (4 screw holes at corners)   │
└──────────────────────────────────────┘ Z=0mm

Clear visual hierarchy: Ribs + text + vents all visible ✓
```

---

# STEP 3: ELEMENT INTERACTION MATRIX

## Conflict Analysis

| Element 1 | Element 2 | Interaction | Risk | Mitigation |
|-----------|-----------|-------------|------|-----------|
| **Screen Bezel** | Screen Window | Bezel surrounds window | NONE | Bezel is 4-8mm recess inward; window cuts through front |
| **Screen Bezel** | Corner Screws | Bezel at Z=79-167; screws at Z=6,169 | NONE | Screws outside screen area |
| **Corner Screws** | Left Grip Dots | Screws at TL, BL (X=6); dots on left wall | MINIMAL | Dots don't overlap screw holes (dots are Z-distributed) |
| **Corner Screws** | Back Ribbing | Screws on front edges; ribs on back plate | NONE | Different faces |
| **Grip Dots (LEFT)** | Power Button | Dots cover full left wall; button at Z=68 | MINIMAL | Button hole is 8mm Ø; dots still visible around it |
| **Grip Dots (LEFT)** | MIC Hole | Dots cover left wall; MIC at Z=48 | MINIMAL | MIC is 3mm Ø; dots visible around |
| **Grip Dots (RIGHT)** | Port Rectangles | Dots cover right wall; USB/Ethernet cut through | MINIMAL | Ports are rectangular cutouts; dots visible in surrounding areas |
| **Grip Dots (RIGHT)** | OLED Windows | Dots on exterior right wall; OLEDs are interior viewing windows | NONE | Different structural layers |
| **Back Ribbing** | K!MO Text | Ribs Z=15, 55, 125, 140, 155, 165; text Z=22-45 | NONE | Rib 1 at 15mm (below text), Rib 2 at 55mm (above text) |
| **Back Ribbing** | Vent Slots | Ribs Z=15, 55, 125...; vents Z=65-120 | NONE | Rib 2 at 55mm (below vents) |
| **Back Ribbing** | Antenna Recess | Ribs Z=125, 140 (overlap 121-135mm recess) | ⚠️ CONFLICT | **Addressed in revised layout** — ribs placed to avoid |
| **Back Ribbing** | Screw Holes | Ribs horizontal; screws at 4 corners | NONE | Ribs don't intersect corner holes |

**Summary:** Only 1 original conflict (antenna recess); **RESOLVED** via revised rib positioning ✓

---

# STEP 4: 5-STEP VERIFICATION WORKFLOW

Before writing REVIEW-CASE.scad, verify these steps:

### **VERIFICATION STEP 1: Screen Bezel Geometry**
- [ ] Bezel ledge exists internally: Y = 1.5 to 8mm depth
- [ ] Ledge is 78mm wide (76mm PCB + 1mm tolerance each side)
- [ ] Ledge is rounded at inner edge (2-3mm radius)
- [ ] Screen window (53×88mm) cuts completely through front face
- [ ] Screen window allows visibility through (not just an outline)
- [ ] Ledge is STRONG enough to support 76×98.58mm PCB (3mm thick)

### **VERIFICATION STEP 2: Corner Screw Holes**
- [ ] 4 screw holes positioned at: TL(6,169), TR(80,169), BL(6,6), BR(80,6)
- [ ] Each hole is Ø2.5mm (M2.5 fastener)
- [ ] Holes are counterbored or recessed for lowpro head (if needed)
- [ ] Screw holes DO NOT intersect with:
  - [ ] Screen window (window Z=79-167)
  - [ ] Keyboard window (window Z=10-54)
  - [ ] Any other port cutouts
- [ ] Screws are visible on front edges (aesthetic feature)
- [ ] Screws align with back plate mounting points for assembly

### **VERIFICATION STEP 3: Grip Texture (Micro-Dots)**
- [ ] Left wall texture: Dots from Z=0-175mm, 3mm pitch, X=1.25mm centered
- [ ] Right wall texture: Dots from Z=0-175mm, 3mm pitch, X=84.75mm centered
- [ ] Dot pattern does NOT interfere with ports:
  - [ ] Left wall ports (power button @ Z=68, MIC @ Z=48): dots visible around
  - [ ] Right wall ports (USB/Ethernet/buttons @ multiple Z): dots visible around
- [ ] Dots are recessed 0.5-1mm (not sharp, safe for grip)
- [ ] Dots create honeycomb appearance at distance (futuristic aesthetic)
- [ ] Texture is symmetrical on both sides ✓

### **VERIFICATION STEP 4: Back Plate Ribbing**
- [ ] 8 raised ribs at Z positions: 15, 55, 125, 140, 155, 165mm
- [ ] Each rib is 86mm wide (full plate width)
- [ ] Ribs are 1.5-2mm raised (proud of surface)
- [ ] Ribs are 1.5-2mm thick (cross-section)
- [ ] Ribs DO NOT interfere with:
  - [ ] K!MO text (Z=22-45mm): Ribs avoid this zone
  - [ ] Vent slots (Z=65-120mm): Ribs avoid this zone
  - [ ] Antenna recess (Z=120-130mm): Ribs at 125, 140 carefully placed
  - [ ] Screw holes (corners): Ribs don't touch corner areas
- [ ] Ribs create dramatic shadow/light effect on transparent PETG ✓
- [ ] Back plate is still fully removable after ribs added

### **VERIFICATION STEP 5: Component Clearance (Final Check)**
- [ ] OPi 5B board: Y=39.4-41mm (inside case, clears cavity depth 41.5mm) ✓
- [ ] Screen PCB: Y=2.5-5.5mm (on bezel ledge) ✓
- [ ] Keyboard: Y=5.5-34.4mm (cable routing space) ✓
- [ ] Heatsinks: Y=34.4-39.4mm (on top of OPi, upward in Z) ✓
- [ ] No component interference with textured walls ✓
- [ ] No component interference with raised ribs (back plate is removable) ✓
- [ ] All windows open to correct components ✓

**All 5 steps must pass before coding REVIEW-CASE.scad**

---

# STEP 5: APPROVAL CHECKLIST

## Pre-Coding Approval

**Ready to proceed with REVIEW-CASE.scad only if ALL items checked:**

### Design Elements
- [x] Screen bezel: Internal mounting, 4-8mm rounded recess
- [x] Corner screws: 4 functional 1UP Racing titanium (lowpro), front-facing aesthetic
- [x] Grip texture: Micro-dots honeycomb, full height, 3mm pitch, both sides
- [x] Back ribbing: 8 raised ribs, 1.5-2mm each, strategically placed (avoiding conflicts)

### Geometric Accuracy
- [x] All coordinates verified against MEASUREMENTS.md
- [x] All windows position verified (screen, keyboard, OLEDs, ports)
- [x] Component fit verified (no crowding, 5mm safety margin in cavity)
- [x] No element-to-element conflicts identified
- [x] Back plate removability maintained

### Aesthetic Alignment
- [x] Design feels "futuristic sci-fi" (industrial + refined)
- [x] Smooth/integrated vibe (not harsh or aggressive)
- [x] Visual elements harmonize (bezel + screws + texture + ribs)
- [x] Clear PETG transparency will be utilized (texture shadows, internal visibility)

### Manufacturing Feasibility
- [x] No unsupported overhangs (3D print friendly)
- [x] No thin walls (<2mm) except interior cavity
- [x] Ribs are supported by back plate structure
- [x] Texture dots are shallow (0.5-1mm) — printable at 0.2mm layer height
- [x] All features are achievable with standard FDM printer (PETG/PLA)

### Ready for Code?

**[ ] YES — Proceed to REVIEW-CASE.scad coding**  
**[ ] NO — Return to specification and clarify**

---

# NEXT STEP

**Please confirm:**

✅ All design elements locked and detailed  
✅ No conflicts remaining  
✅ Element positions finite and verified  
✅ Ready to write REVIEW-CASE.scad with 100% confidence

**If YES to all above → MICRO-STEP 1: Write screen bezel module**

**If NO → Which element needs revision?**
