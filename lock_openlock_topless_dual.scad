/*
 * Openlock Topless connection bay
 */

module openlock_topless_dual_positive(square_basis, height=6) {
    translate([0,-8,0.4]) cube([2,16,height-.4]); 
    translate([square_basis/2,0,0]) rotate([0,0,180]) translate([0,-8,0.4]) cube([2,16,height-.4]); 
}

module openlock_topless_dual_negative(square_basis, supports=true, height=6) {
    module _openlock_topless_chamber(buffer=0, height=6) {
        translate([-buffer,-7,1.4]) cube([2+buffer,7*2,height+1]);
        hull() {
            translate([0,-6,1.4]) cube([2,6*2,height+1]);
            translate([3+0.01,-5,1.4]) cube([2,5*2,height+1]);
        }
        hull() {
            translate([5,-5,1.4]) cube([1,5*2,height+1]);
            translate([6,-5,1.4]) cube([1,5*2,height+1]);
        }
        translate([5,-6.4,1.4]) cube([2,6.4*2,height+1]);
    }
    _openlock_topless_chamber(1, height);
    translate([square_basis/2,0,0]) rotate([0,0,180]) _openlock_topless_chamber(1, height);
}
