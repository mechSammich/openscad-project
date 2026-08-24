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
mount_bezel = 10;
mount_back_th = magnet_th + 4;
mount_w = tablet_w + (2 * mount_bezel);
mount_h = mount_bezel + (3 * magnet_row_offset);
mount_th = mount_back_th + tablet_th;
mount_screw_dia = 4;
mount_screw_angle = 90;

diff() {
    cube([mount_w,mount_h,mount_th], anchor=FRONT+TOP)
   
    /*
        let(p = $parent_size.z+0.1, rad = tablet_r*2) {
            edge_mask(FRONT+RIGHT)
                rounding_edge_mask(l=p.z, rad);
            edge_mask(FRONT+LEFT)
                rounding_edge_mask(l=p.z, rad);
            edge_mask(BACK+RIGHT)
                rounding_edge_mask(l=p.z, rad);
            edge_mask(BACK+LEFT)
                rounding_edge_mask(l=p.z, rad);
        }
        */
        attach(TOP) tag("remove") fwd(mount_bezel) cube([tablet_w,mount_h,tablet_th], anchor = TOP);
}

