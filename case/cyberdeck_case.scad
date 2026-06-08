// ═══════════════════════════════════════════════════════════════
// Cyberdeck Case v4 — Full Detail Build
// BBQ20 PCB + Orange Pi 5B + Waveshare 4" IPS + 0.96" OLED
// ═══════════════════════════════════════════════════════════════
//
// Print: 3 files — case_body(), back_plate(), and power_button()
// Material: CLEAR PETG (transparent) — 0.2mm layer, 40% infill, 3 walls
// Supports: OFF (design is fully self-supporting)
//
// ─── WiFi Antenna note ───────────────────────────────────────
// OPi 5B uses FPC (flexible printed circuit) sticker antennas.
// Size: 40mm × 10mm, Cable: 120mm pigtail to U.FL connector.
// For MAXIMUM WiFi 6 / MIMO signal strength:
//   Antenna 1 → stick VERTICAL on inside of LEFT wall (recessed area)
//   Antenna 2 → stick HORIZONTAL on inside of BACK PLATE (recessed area)
// This 90° angle separation maximizes MIMO spatial diversity. ✓
// No external antenna holes needed — everything is internal.
//
// ─── Assembly order ─────────────────────────────────────────
// 1. Mount OPi 5B on internal standoffs with M2.5 screws
// 2. Attach heatsink pads to OPi chips with thermal tape
// 3. Stick FPC Antenna 1 in the LEFT wall recess (vertical)
// 4. Stick FPC Antenna 2 in the BACK PLATE recess (horizontal)
// 5. Connect antenna U.FL pigtails to OPi connectors
// 6. Solder 2 wires to OPi On/Off key pads → route to left-wall button
// 7. Connect Waveshare screen via flat HDMI + short USB-C (internal)
// 8. Set screen in front window ledge, tape OLED modules in side windows
// 9. Snap BBQ20 PCB + Q20 keyboard into keyboard cavity guide rails
// 10. Route all cables, close back plate with 4× M2.5 screws
// ═══════════════════════════════════════════════════════════════

$fn = 48; // reduce to 16 for fast preview, 48 for final render


// ─── Outer case dimensions ───────────────────────────────────
CASE_W = 86;    // width  (BBQ20 PCB 79.08mm + 3.5mm wall each side)
CASE_H = 175;   // height (screen 98.58 + mid 5mm + kbd 52mm + bezels)
CASE_D = 47;    // depth  (screen 16.5 + OPi 18 + heatsink 5 + shells)
WALL   = 2.5;   // wall thickness minimum
RADIUS = 6;     // corner radius (matches BBQ20 PCB top corner style)


// ─── Screen (Waveshare 4" IPS) ───────────────────────────────
SCR_WIN_W     = 53;   // visible cutout (active area 51.84 + 1mm tolerance)
SCR_WIN_H     = 88;   // visible cutout (active area 86.40 + 1mm tolerance)
SCR_BOARD_W   = 78;   // full PCB width  (76mm + 1mm tolerance each side)
SCR_BOARD_H   = 101;  // full PCB height (98.58mm + 1mm tolerance each side)
SCR_LEDGE     = 1.5;  // lip screen board rests on
SCR_TOP_GAP   = 8;    // bezel above screen

// Screen M2 screw holes (hold screen board to front face)
SCR_SCREW_D   = 2.2;  // M2 clearance
SCR_MARGIN    = 4;    // distance from window edge to screw center


// ─── Keyboard (Q20 + BBQ20 PCB) ──────────────────────────────
KBD_WIN_W     = 69;   // Q20 cutout (67.5mm + 0.75mm tolerance each side)
KBD_WIN_H     = 44;   // Q20 cutout (41.5mm keyboard + 2mm for trackpad row)
KBD_BOTTOM    = 10;   // gap below keyboard window


// ─── OLED displays (0.96" — measured panel: 26.7mm × 19.3mm × 1.7mm) ────
// Both on RIGHT side wall — positions from MEASUREMENTS.md port cutout table:
//   Right wall port map (Z): SW4=28, SW3=40, Eth=83, USB2=103, USB3=113, OLED2=55-75, OLED1=128-148
//   OLED2 fits at Z=55-75 (below Ethernet, above SW3 — safe clearance)
//   OLED1 fits at Z=128-148 (above USB3.0 — good visibility area)
// Wire both to OPi GPIO: OLED1 → I2C1 (0x3C), OLED2 → I2C4 (0x3C)
// Do NOT use JST LED strip connectors — use 4-pin female Dupont wires (2.54mm pitch)
OLED_W        = 27.5; // cutout width  in Y direction (panel 26.7mm + 0.4mm tolerance, per MEASUREMENTS.md)
OLED_H        = 19.8; // cutout height in Z direction (panel 19.3mm + 0.4mm tolerance, per MEASUREMENTS.md)
OLED1_Z       = 128;  // upper OLED bottom edge Z — window is 128-148mm (per MEASUREMENTS.md)
OLED2_Z       = 55;   // lower OLED bottom edge Z — window is 55-75mm (per MEASUREMENTS.md)


// ─── OPi 5B mounting ─────────────────────────────────────────
// Board: 62mm wide × 100mm tall, centered in 86mm wide case
// Margins: (86-62)/2 = 12mm each side
// OPi centered vertically: (175-100)/2 = 37.5mm from top and bottom
OPI_W         = 62;
OPI_H         = 100;
OPI_X         = (CASE_W - OPI_W) / 2;  // 12mm from each side
OPI_Z         = (CASE_H - OPI_H) / 2;  // 37.5mm from top and bottom

// Standoffs inside case body (lift OPi 3mm off back wall for airflow)
// OPi mounting holes at corners, ~3.5mm from each edge
STANDOFF_H    = 3;    // height of standoff post
STANDOFF_OD   = 6;    // outer diameter of post
STANDOFF_ID   = 2.7;  // inner diameter (M2.5 screw)
// Approximate OPi mounting hole positions (from OPi edge):
OPI_HOLE_X    = [4, OPI_W - 4];  // 4mm from left/right edge
OPI_HOLE_Z    = [4, OPI_H - 4];  // 4mm from top/bottom edge


// ─── OPi port layout (corrected from board diagram) ──────────
//
// OPi 5B oriented portrait: 62mm = width (left↔right), 100mm = height (up↓down)
//   LEFT SHORT EDGE  (62mm) → case LEFT wall:  On/Off key, MIC
//   RIGHT SHORT EDGE (62mm) → case RIGHT wall: USB3.0-A, USB2.0-A, Ethernet
//   BOTTOM LONG EDGE (100mm) → faces case BOTTOM (internal): Type-C/Power, Audio, HDMI, WiFi u.FL
//   TOP LONG EDGE    (100mm) → faces case TOP (internal): MicroSD, GPIO, LED
//
// Power routing: OPi Type-C power is internal. A short USB-C cable runs from the
// case BOTTOM edge cutout to the OPi Type-C port. PowerCore connects externally.
// Audio: headphone jack is on OPi bottom long edge → expose at CASE BOTTOM edge.
// MicroSD: on OPi top long edge → expose at CASE TOP (next to antenna holes).

// ─── LEFT WALL ports (OPi LEFT SHORT EDGE, 62mm) ─────────────
// This edge has: On/Off key (mid-left), MIC (lower-left), MaskROM (ignore)

// On/Off key — OPi button is on board surface, NOT on an edge.
// Best solution: solder 2 wires to OPi On/Off key solder pads → external momentary switch.
// A standard 6mm tactile switch snaps into this hole. No printed nub needed.
// OPi On/Off key position: ~30mm from OPi bottom edge (verified in MEASUREMENTS.md).
PWR_BTN_D     = 8;    // 8mm hole fits standard 6mm momentary switch body + tolerance
PWR_BTN_Z     = OPI_Z + 30; // ~68mm from case bottom (matches MEASUREMENTS.md spec)

// MIC hole — OPi built-in mic at lower-left edge, ~10mm from OPi bottom (verified in MEASUREMENTS.md)
// Transparent PETG transmits ~60% of sound without holes — optional feature.
// This hole provides better acoustic coupling for on-device recording.
MIC_D         = 3;    // 3mm hole (matches MEASUREMENTS.md spec for clarity)
MIC_Z         = OPI_Z + 10;  // ~48mm from case bottom (matches MEASUREMENTS.md spec)

// ─── BOTTOM EDGE ports (OPi BOTTOM LONG EDGE, internal cables) ──
// Type-C/Power → case bottom edge (short internal USB-C cable from here to OPi)
TYPEC_PWR_W   = 10;
TYPEC_PWR_H   = 4;
TYPEC_PWR_X   = (CASE_W / 2) - 15;  // offset left of center on bottom edge

// Audio 3.5mm jack → case bottom edge (short internal cable or direct expose)
AUDIO_D       = 6.5;
AUDIO_X       = CASE_W / 2;  // centered on bottom edge

// ─── TOP EDGE ports (OPi TOP LONG EDGE, internal) ──────────────
// MicroSD slot → case top edge (between antenna holes)
MSD_W         = 15;
MSD_H         = 2.5;
MSD_X         = CASE_W - 35;  // right side of top edge, away from antenna holes


// ── OPi ports — RIGHT wall of case (from MEASUREMENTS.md spec table) ──────
// USB3.0(A) upper, USB2.0(A) lower — stacked vertically to save horizontal space
USBA_W        = 15;   // width for USB Type-A port cutout
USBA_H        = 8;    // height for USB Type-A port cutout
USBA3_Z       = 113;  // USB3.0 — ~113mm from case bottom (per MEASUREMENTS.md)
USBA2_Z       = 103;  // USB2.0 — ~103mm from case bottom (per MEASUREMENTS.md)

// Gigabit Ethernet (RJ45) — mid-right, cleanly below USB ports
// Note: RJ45 is large (16mm × 13.5mm). Including cutout but marked optional in MEASUREMENTS.md
// You can block it with a printed plug since you have WiFi6.
ETH_W         = 17;   // width for RJ45 connector
ETH_H         = 14;   // height for RJ45 connector
ETH_Z         = 83;   // Ethernet at ~83mm from case bottom (per MEASUREMENTS.md)


// ── BBQ20 side buttons (SW3, SW4) — from MEASUREMENTS.md spec table ──────
// Programmable buttons on BBQ20 PCB — accessible from right side wall
// Positioned in keyboard section area, matching spec positions
SW_D          = 5;    // button hole diameter (5mm per MEASUREMENTS.md)
SW3_Z         = 40;   // SW3 at ~40mm from case bottom (per MEASUREMENTS.md)
SW4_Z         = 28;   // SW4 at ~28mm from case bottom (per MEASUREMENTS.md)


// ── WiFi antennas (FPC sticker type — all internal, per MEASUREMENTS.md) ─
// OPi 5B uses FPC "sticker" antennas: 40mm × 10mm patch, 120mm pigtail
// These mount INSIDE the case — no external antenna holes needed.
// 90° placement for MIMO spatial diversity = maximum WiFi 6 performance.
FPC_W         = 40;   // FPC antenna patch long dimension (40mm per MEASUREMENTS.md)
FPC_H         = 10;   // FPC antenna patch short dimension (10mm per MEASUREMENTS.md)
FPC_DEPTH     = 0.6;  // recess depth in wall for adhesive to sit flush
// Antenna 1 (LEFT wall): vertical patch, Z=100–140mm (per MEASUREMENTS.md)
// Antenna 2 (BACK plate): horizontal patch, Z=120–130mm (per MEASUREMENTS.md)


// ─── LED status window ───────────────────────────────────────
// OPi status LED — small clear window on TOP edge
LED_D         = 3;
LED_X         = CASE_W - 20;  // right side of top edge


// ─── Back plate screws ───────────────────────────────────────
SCREW_D       = 2.7;   // M2.5 clearance
SCREW_INSET   = 6;     // from corner


// ════════════════════════════════════════════════════════════
// HELPERS
// ════════════════════════════════════════════════════════════

// Rounded box using hull — faster than minkowski, same result
module rounded_box(w, h, d, r) {
    hull() {
        for (x = [r, w - r])
            for (z = [r, h - r])
                translate([x, 0, z])
                    rotate([-90, 0, 0])
                        cylinder(r=r, h=d);
    }
}

// Standoff post for mounting OPi board
module standoff(h, od, id) {
    difference() {
        cylinder(d=od, h=h);
        cylinder(d=id, h=h + 1);
    }
}



// ════════════════════════════════════════════════════════════
// MAIN CASE BODY
// ════════════════════════════════════════════════════════════
module case_body() {
    difference() {

        // ── Outer shell ──────────────────────────────────────
        rounded_box(CASE_W, CASE_H, CASE_D, RADIUS);

        // ── Inner cavity (open back for component insertion) ─
        translate([WALL, WALL, WALL])
            cube([CASE_W - 2*WALL,
                  CASE_D - WALL,       // open at back
                  CASE_H - 2*WALL]);

        // ════════════════════════════════════════════════════
        // FRONT FACE CUTOUTS
        // ════════════════════════════════════════════════════

        // ── Screen window ────────────────────────────────────
        scr_x = (CASE_W - SCR_WIN_W) / 2;
        scr_z = CASE_H - SCR_TOP_GAP - SCR_WIN_H;
        translate([scr_x, -1, scr_z])
            cube([SCR_WIN_W, WALL + 2, SCR_WIN_H]);

        // ── Screen board ledge (PCB rests on this lip) ───────
        // 1.5mm step inside the screen opening — Waveshare board drops in flush
        translate([(CASE_W - SCR_BOARD_W) / 2, WALL, CASE_H - SCR_TOP_GAP - SCR_BOARD_H])
            cube([SCR_BOARD_W, SCR_LEDGE, SCR_BOARD_H]);

        // ── Screen M2 screw holes (4 corners) ────────────────
        // Screen board is secured to front face with M2 × 6mm screws
        for (sx = [scr_x - SCR_MARGIN, scr_x + SCR_WIN_W + SCR_MARGIN - SCR_SCREW_D])
            for (sz = [scr_z - SCR_MARGIN, scr_z + SCR_WIN_H + SCR_MARGIN])
                translate([sx, -1, sz])
                    rotate([-90, 0, 0])
                        cylinder(d=SCR_SCREW_D, h=WALL + 2);

        // ── Keyboard window ──────────────────────────────────
        // Q20 keyboard + optical trackpad row all exposed through this cutout
        translate([(CASE_W - KBD_WIN_W) / 2, -1, KBD_BOTTOM])
            cube([KBD_WIN_W, WALL + 2, KBD_WIN_H]);

        // ════════════════════════════════════════════════════
        // RIGHT SIDE WALL CUTOUTS
        // ════════════════════════════════════════════════════

        // ── OLED window #1 (upper — I2C1, address 0x3C) ─────
        // cube: [through wall, Y=horizontal width on wall, Z=vertical height on wall]
        translate([CASE_W - WALL - 1,
                   (CASE_D - OLED_W) / 2,   // OLED_W = 27.5mm centered in depth
                   OLED1_Z])
            cube([WALL + 2, OLED_W, OLED_H]);  // 27.5mm wide × 19.8mm tall

        // ── OLED window #2 (lower — I2C4, address 0x3C) ─────
        translate([CASE_W - WALL - 1,
                   (CASE_D - OLED_W) / 2,
                   OLED2_Z])
            cube([WALL + 2, OLED_W, OLED_H]);

        // ── USB3.0 Type-A (OPi, upper) ───────────────────────
        translate([CASE_W - WALL - 1,
                   (CASE_D - USBA_W) / 2,
                   USBA3_Z])
            cube([WALL + 2, USBA_W, USBA_H]);

        // ── USB2.0 Type-A (OPi, lower) ───────────────────────
        translate([CASE_W - WALL - 1,
                   (CASE_D - USBA_W) / 2,
                   USBA2_Z])
            cube([WALL + 2, USBA_W, USBA_H]);

        // ── Gigabit Ethernet (OPi) — comment out to block ────
        // WiFi6 makes this optional. Block with a printed plug if unused.
        translate([CASE_W - WALL - 1,
                   (CASE_D - ETH_W) / 2,
                   ETH_Z])
            cube([WALL + 2, ETH_W, ETH_H]);

        // ── BBQ20 SW3 button (right side, keyboard section) ──
        translate([CASE_W - WALL - 1, CASE_D / 2, SW3_Z])
            rotate([0, 90, 0])
                cylinder(d=SW_D, h=WALL + 2);

        // ── BBQ20 SW4 button (right side, keyboard section) ──
        translate([CASE_W - WALL - 1, CASE_D / 2, SW4_Z])
            rotate([0, 90, 0])
                cylinder(d=SW_D, h=WALL + 2);

        // ════════════════════════════════════════════════════
        // LEFT SIDE WALL CUTOUTS (OPi left short edge: On/Off, MIC)
        // ════════════════════════════════════════════════════

        // ── Power button (presses OPi On/Off key) ────────────
        // Printed nub sits in this hole and presses the OPi button.
        translate([-1, CASE_D / 2, PWR_BTN_Z])
            rotate([0, 90, 0])
                cylinder(d=PWR_BTN_D, h=WALL + 2);

        // ── MIC hole (OPi left edge, lower position) ─────────
        translate([-1, CASE_D / 2, MIC_Z])
            rotate([0, 90, 0])
                cylinder(d=MIC_D, h=WALL + 2);

        // ════════════════════════════════════════════════════
        // BOTTOM EDGE CUTOUTS (OPi bottom long edge via internal cables)
        // Power + audio are on OPi bottom long edge → routed to case bottom
        // ════════════════════════════════════════════════════

        // ── Type-C Power In (OPi 5V/4A) — BOTTOM FACE ────────
        // Cuts through the CASE BOTTOM face only (Z=0). Previous version
        // incorrectly cut through the front wall causing the gap below keyboard.
        // Short internal USB-C cable connects this hole to the OPi Type-C port.
        translate([TYPEC_PWR_X, (CASE_D - TYPEC_PWR_H) / 2, -1])
            cube([TYPEC_PWR_W, TYPEC_PWR_H, WALL + 2]);

        // ── Audio In/Out 3.5mm jack — BOTTOM FACE ─────────────
        translate([AUDIO_X, CASE_D / 2, -1])
            cylinder(d=AUDIO_D, h=WALL + 2);

        // ════════════════════════════════════════════════════
        // TOP FACE CUTOUTS
        // ════════════════════════════════════════════════════

        // ── FPC Antenna 1 recess — inside LEFT wall ───────────
        // Vertical 40mm × 10mm patch. Self-adhesive FPC sits in this groove.
        // 90° to Antenna 2 on back plate = maximum MIMO spatial diversity.
        // Position: Z=100–140mm (per MEASUREMENTS.md optimal placement section)
        translate([WALL - FPC_DEPTH, (CASE_D - FPC_H) / 2, 100])
            cube([FPC_DEPTH + 0.1, FPC_H, FPC_W]);

        // ── OPi status LED window ─────────────────────────────
        translate([LED_X, CASE_D / 2, CASE_H - WALL - 1])
            cylinder(d=LED_D, h=WALL + 2);

        // ── MicroSD Card Slot (OPi top long edge → case top) ─
        // OPi GPIO header faces up internally — MicroSD slot is at
        // top long edge. Expose it at the case top edge.
        translate([MSD_X, (CASE_D - MSD_W) / 2, CASE_H - WALL - 1])
            cube([MSD_H, MSD_W, WALL + 2]);

        // ════════════════════════════════════════════════════
        // BACK PLATE SCREW HOLES (blind, 8mm deep from back)
        // Screws enter from back plate and grip into solid corner bosses.
        // Using self-tapping M2.5 × 8mm — bites into PLA without inserts.
        // If threads strip, heat-set inserts (M2.5) drop right in.
        // ════════════════════════════════════════════════════
        for (x = [SCREW_INSET, CASE_W - SCREW_INSET])
            for (z = [SCREW_INSET, CASE_H - SCREW_INSET])
                translate([x, CASE_D + 0.5, z])
                    rotate([-90, 0, 0])
                        cylinder(d=SCREW_D, h=8.5);   // 8mm into boss, 0.5 past back face
    }

    // ════════════════════════════════════════════════════════
    // INTERNAL FEATURES (added, not subtracted)
    // ════════════════════════════════════════════════════════

    // ── OPi 5B mounting standoffs (4 corners) ────────────────
    // Board sits on these posts, screwed down with M2.5 × 6mm
    // Internal cavity: Y=2.5mm (front) to Y=44mm (back wall interior face)
    // Back plate interior: Y=44mm. Standoffs at Y=41mm (top surface touching board)
    // Provides: 3mm standoff height + 3mm airflow gap = proper heatsink cooling clearance
    // Correct formula: (CASE_D - 3) - STANDOFF_H = (47 - 3) - 3 = 41mm ✓
    for (ox = OPI_HOLE_X)
        for (oz = OPI_HOLE_Z)
            translate([OPI_X + ox, (CASE_D - 3) - STANDOFF_H, OPI_Z + oz])
                standoff(STANDOFF_H, STANDOFF_OD, STANDOFF_ID);

    // ── Keyboard cavity guide rails ───────────────────────────
    // Two small rails that BBQ20 PCB (79mm wide) slots into
    // Prevents keyboard PCB from shifting left/right
    rail_x_left  = (CASE_W - 80) / 2;  // just outside BBQ20 PCB width
    rail_x_right = rail_x_left + 80;
    rail_z       = KBD_BOTTOM - 1;
    rail_h       = KBD_WIN_H + 2;
    rail_d       = 3;
    rail_w       = 2;

    translate([rail_x_left, WALL + 2, rail_z])
        cube([rail_w, rail_d, rail_h]);
    translate([rail_x_right - rail_w, WALL + 2, rail_z])
        cube([rail_w, rail_d, rail_h]);

    // ── Back corner screw bosses ──────────────────────────────
    // Solid cylinders at the 4 corners near the back wall.
    // The blind screw holes above drill into these — gives the
    // self-tapping M2.5 screws ~8mm of solid PLA to grip.
    // Without bosses, screws would enter hollow cavity and not hold.
    for (bx = [SCREW_INSET, CASE_W - SCREW_INSET])
        for (bz = [SCREW_INSET, CASE_H - SCREW_INSET])
            translate([bx, CASE_D - 8, bz])
                rotate([-90, 0, 0])
                    cylinder(d=STANDOFF_OD, h=8);   // 8mm boss, same OD as OPi standoffs

    // Note: WiFi FPC antennas mount via self-adhesive backing.
    // Antenna 1 → LEFT wall recess (see cutout above, vertical polarization)
    // Antenna 2 → BACK PLATE recess (horizontal polarization, 90° to Ant.1)
    // Cable routing: 120mm pigtail is plenty to reach from OPi u.FL to either wall.
}


// ════════════════════════════════════════════════════════════
// BACK PLATE
// Separate print — screws onto case body with 4× M2.5 bolts
// ════════════════════════════════════════════════════════════
module back_plate() {
    difference() {
        rounded_box(CASE_W, CASE_H, 3, RADIUS);

        // ── Back plate screw holes ────────────────────────────
        for (x = [SCREW_INSET, CASE_W - SCREW_INSET])
            for (z = [SCREW_INSET, CASE_H - SCREW_INSET])
                translate([x, -1, z])
                    rotate([-90, 0, 0])
                        cylinder(d=SCREW_D, h=5);

        // ── Heatsink ventilation slots ────────────────────────
        // 6 horizontal slots over OPi heatsink area
        // Heatsink is roughly at Z = 60-130mm (OPi center zone)
        for (i = [0:5])
            translate([20, -1, 65 + i * 11])
                cube([CASE_W - 40, 4, 7]);

        // ── FPC Antenna 2 recess — inside BACK PLATE surface ─
        // Horizontal 40mm × 10mm patch — 90° to Antenna 1 on left wall.
        // Position: Z=120–130mm (per MEASUREMENTS.md optimal placement section)
        // Self-adhesive FPC sticker sits flush in this shallow groove.
        translate([CASE_W/2 - FPC_W/2, -FPC_DEPTH, 125])
            cube([FPC_W, FPC_DEPTH + 0.1, FPC_H]);

        // ── K!MO signature vent ────────────────────────────────
        // Maker's mark cut through the back plate — lower section (Z≈22–45mm per MEASUREMENTS.md).
        // Positioned BELOW the OPi heatsink ventilation area for clean visibility.
        // mirror([1,0,0]): Corrects horizontal flip so text reads "K!MO" (not "OM!K") ✓
        // rotate([90,0,0]): text "up" → +Z (right-side up from outside), extrusion → -Y (into plate)
        // If font is missing: File → Font list in OpenSCAD to find available bold fonts.
        translate([CASE_W/2, 4, 33])
            mirror([1, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = 5)
                        text("K!MO",
                             size    = 15,
                             font    = "Arial Black",
                             halign  = "center",
                             valign  = "baseline");
    }
}


// ════════════════════════════════════════════════════════════
// POWER BUTTON NUB
// Tiny separate print — sits in the left-side power button hole
// Translates finger press to OPi On/Off key
// Print 2-3 of these (easy to lose)
// ════════════════════════════════════════════════════════════
module power_button() {
    // Outer cap (finger contact, sits flush with case exterior)
    cylinder(d=PWR_BTN_D - 0.4, h=2, $fn=32);
    // Inner shaft (goes through hole, presses OPi button)
    translate([0, 0, 2])
        cylinder(d=3, h=WALL + 1.5, $fn=24);
}


// ════════════════════════════════════════════════════════════
// COMPONENT VISUALIZATION
// Use show_all() in F5 Preview to see everything inside the case.
// All positions are derived from verified measurements in MEASUREMENTS.md.
// Colors: blue=OPi, gray=screen, green=BBQ20, yellow=OLED, orange=antenna
// ════════════════════════════════════════════════════════════
module components_preview() {

    // ── Orange Pi 5B board ────────────────────────────────────
    // Portrait: 62mm wide (X) × 100mm tall (Z), ~1.6mm PCB thickness (Y)
    // Sits 3mm from inner back wall on standoffs. Board back face at Y=41.5.
    color([0.18, 0.36, 0.78, 0.95])
        translate([OPI_X, 41.5 - 1.6, OPI_Z])
            cube([OPI_W, 1.6, OPI_H]);

    // ── Heatsinks (copper) on OPi chip tops ───────────────────
    // Chips face front (decreasing Y). Main SoC ~center-left of board.
    // 4× heatsink stacks at roughly verified chip positions.
    color([0.72, 0.45, 0.20, 1]) {
        translate([OPI_X + 15, 34, OPI_Z + 30]) cube([15, 5, 15]); // RK3588S SoC
        translate([OPI_X + 35, 36, OPI_Z + 30]) cube([15, 3, 15]); // RAM
        translate([OPI_X + 10, 37, OPI_Z + 55]) cube([8,  2,  8]); // aux chip
        translate([OPI_X + 45, 37, OPI_Z + 55]) cube([6,  2,  6]); // aux chip
    }

    // ── M2.5 brass standoffs (4 corners) ─────────────────────
    // These hold the OPi board 3mm off the back wall.
    color([0.85, 0.65, 0.13, 1])
        for (ox = OPI_HOLE_X)
            for (oz = OPI_HOLE_Z)
                translate([OPI_X + ox, 41.5, OPI_Z + oz])
                    rotate([90, 0, 0])
                        cylinder(d=STANDOFF_OD, h=STANDOFF_H, $fn=16);

    // ── Waveshare 4" screen PCB ───────────────────────────────
    // PCB 76mm × 98.58mm, sits just inside front wall on 1.5mm ledge.
    // In this Y-axis system, front wall = 0, screen PCB starts at Y=WALL.
    color([0.35, 0.35, 0.35, 0.9])
        translate([(CASE_W - SCR_BOARD_W) / 2, WALL, CASE_H - SCR_TOP_GAP - SCR_BOARD_H])
            cube([SCR_BOARD_W, 3, SCR_BOARD_H]);

    // ── Active display area (glowing cyan) ────────────────────
    // Shows what's visible through the screen window cutout.
    color([0, 0.85, 1, 0.4])
        translate([(CASE_W - SCR_WIN_W) / 2, 0, CASE_H - SCR_TOP_GAP - SCR_WIN_H])
            cube([SCR_WIN_W, WALL + 0.5, SCR_WIN_H]);

    // ── BBQ20 PCB (keyboard controller) ──────────────────────
    // 79.08mm × 52.10mm PCB, sits in keyboard rail guides just inside front face.
    // BBQ20 PCB is in the bottom half, behind the keyboard window.
    color([0.12, 0.55, 0.18, 0.9])
        translate([(CASE_W - 79.08) / 2, WALL + 2, KBD_BOTTOM])
            cube([79.08, 1.2, 52.1]);

    // ── Q20 keyboard (physical keys, above BBQ20 PCB) ─────────
    // Key matrix: ~67.5mm × 41.5mm, slightly in front of BBQ20 PCB
    color([0.15, 0.15, 0.15, 0.8])
        translate([(CASE_W - 67.5) / 2, WALL, KBD_BOTTOM + 1])
            cube([67.5, 2, 41.5]);

    // ── OLED displays (×2, right side wall) ───────────────────
    // Yellow face pressed against right wall cutout.
    // OLED1 (upper, I2C1), OLED2 (lower, I2C4).
    color([1, 0.92, 0.05, 0.95])
        for (oz = [OLED1_Z, OLED2_Z])
            translate([CASE_W - WALL - 1.7, (CASE_D - OLED_W) / 2, oz])
                cube([1.7, OLED_W, OLED_H]);

    // ── FPC Antenna 1 — left wall, vertical 40mm × 10mm ──────
    // Orange sticker, self-adhesive in shallow recess on inner left wall.
    color([1, 0.45, 0.0, 0.85])
        translate([WALL - FPC_DEPTH + 0.1, (CASE_D - FPC_H) / 2, CASE_H - 75])
            cube([0.5, FPC_H, FPC_W]);  // vertical patch (FPC_W=40 tall, FPC_H=10 wide)

    // ── FPC Antenna 2 — back plate, horizontal 40mm × 10mm ───
    // Same material, 90° to Antenna 1 for MIMO spatial diversity.
    color([1, 0.45, 0.0, 0.85])
        translate([CASE_W/2 - FPC_W/2, CASE_D - WALL - 0.5, CASE_H - 55])
            cube([FPC_W, 0.5, FPC_H]);  // horizontal patch

    // ── Internal cable stubs (approximate routing) ─────────────
    // Not to scale — just gives a sense of cable bulk inside.
    // HDMI flat cable: screen → OPi HDMI (routes along left wall)
    color([0.5, 0.5, 0.5, 0.4])
        translate([WALL + 1, 15, 80])
            cube([3, 20, 60]);

    // USB-C power cable: case bottom port → OPi
    color([0.5, 0.5, 0.5, 0.4])
        translate([20, 15, 1])
            cube([3, 20, 37]);
}


// ── show_all() — full preview with ghost case + solid components ──
// Press F5 in OpenSCAD to see this. Colors only show in Preview mode.
// NOTE: back plate is shown in-place (at back of case) for this preview.
module show_all() {
    // Ghost-transparent case shell (clear PETG look)
    // alpha=0.15 — faint enough to see components through, solid enough to see the shell
    color([0.88, 0.96, 1.0, 0.15]) case_body();
    color([0.88, 0.96, 1.0, 0.15])
        translate([0, CASE_D - 3, 0]) back_plate();

    components_preview();
}


// ════════════════════════════════════════════════════════════
// RENDER — Export wrappers with correct orientation
//
// The case is built correctly but displayed in portrait orientation.
// STL exports should maintain this orientation for 3D printer slicing.
// 
// Export guide:
//   1. UNCOMMENT: rotate_and_export_body();
//   2. UNCOMMENT: rotate_and_export_back_plate();
//   3. UNCOMMENT: rotate_and_export_power_button();
//
// Visualization (F5 Preview):
//   show_all_correct() → see all components in correct portrait orientation
// ════════════════════════════════════════════════════════════

// ── Export wrappers — maintain correct orientation ──────────────
module rotate_and_export_body() {
    rotate([0, 0, 0])  // Case body exports in native orientation (portrait)
        case_body();
}

module rotate_and_export_back_plate() {
    rotate([0, 0, 0])  // Back plate exports in native orientation
        back_plate();
}

module rotate_and_export_power_button() {
    rotate([0, 0, 0])  // Power button exports in native orientation
        power_button();
}

// ── Full visualization with correct orientation ──────────────
module show_all_correct() {
    // All components in correct portrait orientation
    // Front: screen window visible
    // Right: OLED windows visible
    // Bottom: keyboard window visible
    // Back: K!MO signature visible at lower section
    color([0.88, 0.96, 1.0, 0.15]) case_body();
    color([0.88, 0.96, 1.0, 0.15])
        translate([0, CASE_D - 3, 0]) back_plate();
    components_preview();
}

// ════════════════════════════════════════════════════════════
// ACTIVE RENDER — Use one of these to view or export
// ════════════════════════════════════════════════════════════

// For preview in F5 (correct portrait orientation, all parts visible):
show_all_correct();

// For STL export — uncomment ONE of these, then File > Export as STL:
//rotate_and_export_body();     // → body.stl (main case shell)
//rotate_and_export_back_plate(); // → back.stl (removable back plate with K!MO)
//rotate_and_export_power_button(); // → btn.stl (power button nub, print 2-3)
