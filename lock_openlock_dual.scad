/*
 * Openlock connection bay
 */

module openlock_dual_chamber(square_basis, buffer=0) {
    module _main_bay() {
        add = TOPLESS == "true" ? 10 : 0;
        translate([-buffer,-7,1.4]) cube([2+buffer,7*2,4.2+add]);
        hull() {
            translate([0,-6,1.4]) cube([2,6*2,4.2+add]);
            translate([3+0.01,-5,1.4]) cube([2,5*2,4.2+add]);
        }
        translate([5,-6.4,1.4]) cube([square_basis/2-11,6.4*2,4.2+add]);
    }
    _main_bay();
    translate([square_basis/2,0,0]) rotate([0,0,180]) _main_bay();
}

module openlock_dual_supports(square_basis) {
    module support() {
        translate([-1.1,2.05,1.2]) cube([3.1,1,4.6]);
        hull() {
            translate([-1.1,2.05,1.4]) cube([3.1,1,2.1]);
            translate([-1.1,2.05-.2,1.9]) cube([3.1,1.4,1.1]);
        }
        hull() {
            translate([-1.1,2.05,3.5]) cube([3.1,1,2.1]);
            translate([-1.1,2.05-.2,4.0]) cube([3.1,1.4,1.1]);
        }
    }
    if (TOPLESS != "true") {
        support();
        mirror([0,1,0]) support();
        translate([square_basis/2,0,0]) rotate([0,0,180]) support();
        translate([square_basis/2,0,0]) rotate([0,0,180]) mirror([0,1,0]) support();
    }
}

module openlock_dual_positive(square_basis) {
    translate([0,-8,0.4]) cube([2,16,5.6]); 
    translate([square_basis/2,0,0]) rotate([0,0,180]) translate([0,-8,0.4]) cube([2,16,5.6]); 
}

module openlock_dual_negative(square_basis, supports="true") {
    difference() {
        openlock_dual_chamber(square_basis, 1);
        if(supports == "true") {
            openlock_dual_supports(square_basis);
        }
    }
}
