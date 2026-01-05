/*
 * Flex Magnet
 */
module flex_magnetic_dual_positive(square_basis, magnet_hole=6, height=6) {
    if (magnet_hole > 0) {
        hull() {
            translate([0.25,-magnet_hole/2-1+.25,0]) cube([square_basis/2-.5,magnet_hole+2-.5,1]);
            translate([0,-magnet_hole/2-1,.4]) cube([square_basis/2,magnet_hole+2,height-.4]);
        }
    }
}

module flex_magnetic_dual_negative(square_basis, magnet_hole=6, height=6) {
    if (magnet_hole > 0) {
        translate([1,-magnet_hole/2,1]) cube([square_basis/2-2,magnet_hole,height+2]);
            translate([1,-.9,-1]) cube([square_basis/2-2,.9*2,10]);
    }
}
