// magnetic tablet wall stand

include <../../BOSL2/std.scad>
// use <../../openscad-library/YOUR_LIBRARY_DIRECTORY/YOUR_LIBRARY.scad>

magnet_dia = 4;
magnet_th = 2;
magnet_row_offset = 3.25;
magnet_channel_w = 165;
magnet_channel_offset = 20; // check this
magnet_barrier_th = 1;
tablet_w = 195;
tablet_th = 6.5;
tablet_r = 3.25;
tablet_inset = (3 * magnet_row_offset);
mount_bezel = 10;
mount_back_th = magnet_th + 4;
mount_w = tablet_w + (2 * mount_bezel);
mount_h = mount_bezel + tablet_inset;
mount_th = mount_back_th + tablet_th;
mount_screw_dia = 4;
mount_screw_angle = 90;

diff() {
    cube([mount_w,mount_h,mount_th], anchor=TOP) {
        attach(TOP) tag("remove") fwd(mount_bezel-(tablet_inset/2)-0.125) cube([tablet_w,tablet_inset,tablet_th], anchor = TOP);
        attach(BOTTOM) tag("remove") fwd(mount_bezel-(magnet_dia/2)-magnet_row_offset) cube([tablet_w,magnet_dia,mount_back_th-magnet_th], anchor = TOP);
    }
}

