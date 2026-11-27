// paper-window mount
// Frame: X = Pi long axis (landscape), Y = Pi short axis, Z = 0 at the wall face.
// Display faces +Z; the tray extends into the wall (-Z).

/* [Raspberry Pi Zero W] */
pi_len       = 65;    // board length (X)
pi_wid       = 30;    // board width (Y)
pi_hole_dx   = 58;    // mounting hole spacing (X)
pi_hole_dy   = 23;    // mounting hole spacing (Y)
pi_pcb_t     = 1.4;   // PCB thickness

/* [E-paper HAT and display] */
hat_header_h = 8.5;   // header stack height between Pi and HAT
hat_pcb_t    = 1.6;   // HAT PCB thickness
display_t    = 1.2;   // display module thickness above HAT

/* [Button board] */
btn_hole_w   = 17.75; // hole spacing (X)
btn_hole_h   = 25;    // hole spacing (Y)
btn_pcb_t    = 1.6;   // PCB thickness
btn_margin   = 3.5;   // outline beyond hole centres
btn_gap      = 4;     // gap between Pi right edge and board outline
btn_top_z    = -4;    // button PCB top relative to front face

/* [Mount hardware] */
boss_d       = 6;     // standoff outer diameter
boss_hole_d  = 2.5;   // pilot for M2.5 self-tapping screw
boss_h       = 3;     // floor to Pi underside

/* [Shell and bezel] */
wall_t       = 2;     // shell wall and floor thickness
bezel_t      = 2;     // bezel plate thickness
bezel_rim    = 6;     // bezel overlap onto wall face
clr          = 0.5;   // fit clearance around boards

/* [Passthroughs] */
sd_y         = -8;    // SD slot centre (Y), placeholder
sd_w         = 14;    // SD slot width
usb_x        = 20;    // USB/HDMI centre (X), placeholder
usb_w        = 22;    // USB/HDMI opening width
wire_d       = 14;    // wiring hole in floor
wire_x       = -10;   // wiring hole centre (X)
wire_y       = 0;     // wiring hole centre (Y)
side_open_w  = 25;    // +Y wall opening width (X) for button board header and wires

/* [View] */
show_parts   = false; // show ghosted boards in preview
$fn = 48;

// Z stack (front face at 0)
hat_top_z   = -display_t;
hat_bot_z   = hat_top_z - hat_pcb_t;
pi_top_z    = hat_bot_z - hat_header_h;
pi_bot_z    = pi_top_z - pi_pcb_t;
btn_bot_z   = btn_top_z - btn_pcb_t;
floor_top_z = pi_bot_z - boss_h;
floor_bot_z = floor_top_z - wall_t;

// X/Y layout
btn_outline_w = btn_hole_w + 2 * btn_margin;
btn_outline_h = btn_hole_h + 2 * btn_margin;
btn_x         = pi_len / 2 + btn_gap + btn_outline_w / 2;

in_x0 = -pi_len / 2 - clr;
in_x1 = btn_x + btn_outline_w / 2 + clr;
in_y  = max(pi_wid, btn_outline_h) + 2 * clr;
in_y0 = -in_y / 2;
in_y1 = in_y / 2;
out_x0 = in_x0 - wall_t;
out_x1 = in_x1 + wall_t;
out_y0 = in_y0 - wall_t;
out_y1 = in_y1 + wall_t;

pi_holes  = [for (sx = [-1, 1], sy = [-1, 1]) [sx * pi_hole_dx / 2, sy * pi_hole_dy / 2]];
btn_holes = [for (sx = [-1, 1], sy = [-1, 1]) [btn_x + sx * btn_hole_w / 2, sy * btn_hole_h / 2]];

module rrect(x0, x1, y0, y1, z0, z1, r = 3) {
    translate([0, 0, z0])
        linear_extrude(z1 - z0)
            hull() for (px = [x0 + r, x1 - r], py = [y0 + r, y1 - r])
                translate([px, py]) circle(r);
}

module boss(p, top) {
    translate([p[0], p[1], floor_top_z]) cylinder(d = boss_d, h = top - floor_top_z);
}

module pilot(p, top) {
    translate([p[0], p[1], floor_top_z + 0.5]) cylinder(d = boss_hole_d, h = top - floor_top_z + 0.5);
}

module tray() {
    difference() {
        union() {
            difference() {
                rrect(out_x0, out_x1, out_y0, out_y1, floor_bot_z, 0, 3);
                rrect(in_x0, in_x1, in_y0, in_y1, floor_top_z, 1, 1);
            }
            for (p = pi_holes)  boss(p, pi_bot_z);
            for (p = btn_holes) boss(p, btn_bot_z);
        }
        for (p = pi_holes)  pilot(p, pi_bot_z);
        for (p = btn_holes) pilot(p, btn_bot_z);

        // wiring bundle hole through floor
        translate([wire_x, wire_y, floor_bot_z - 1])
            cylinder(d = wire_d, h = floor_top_z - floor_bot_z + 1.5);

        // SD card slot, -X wall
        translate([out_x0 - 1, sd_y - sd_w / 2, pi_bot_z - 2])
            cube([wall_t + 2, sd_w, pi_top_z - pi_bot_z + 4]);

        // USB / HDMI openings, -Y wall
        translate([usb_x - usb_w / 2, out_y0 - 1, pi_bot_z - 2])
            cube([usb_w, wall_t + 2, pi_top_z - pi_bot_z + 4]);

        // button board header and wire opening, +Y wall
        translate([btn_x - side_open_w / 2, in_y1 - 0.5, floor_top_z])
            cube([side_open_w, wall_t + 1, 1 - floor_top_z]);
    }
}

module bezel() {
    difference() {
        rrect(out_x0 - bezel_rim, out_x1 + bezel_rim,
              out_y0 - bezel_rim, out_y1 + bezel_rim, 0, bezel_t, 4);
        rrect(in_x0, in_x1, in_y0, in_y1, -1, bezel_t + 1, 1);
    }
}

module parts() {
    %translate([-pi_len / 2, -pi_wid / 2, pi_bot_z]) cube([pi_len, pi_wid, pi_pcb_t]);
    %translate([-pi_len / 2, -pi_wid / 2, hat_bot_z]) cube([pi_len, pi_wid, hat_pcb_t]);
    %translate([-pi_len / 2, -pi_wid / 2, hat_top_z]) cube([pi_len, pi_wid, display_t]);
    %translate([btn_x - btn_outline_w / 2, -btn_outline_h / 2, btn_bot_z])
        cube([btn_outline_w, btn_outline_h, btn_pcb_t]);
    %translate([btn_x, 0, btn_top_z]) cylinder(d = 6, h = -btn_top_z);
}

if (show_parts) parts();
tray();
bezel();
