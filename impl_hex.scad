include <connectors.scad>

//difference() {
//    equilateral_triangle(25.4*2, 6);
//    translate([12.7,0,0]) translate([0,0,-1]) equilateral_triangle(25.4, 8);
//}


module equilateral_triangle(side, height) {
    linear_extrude(height=height) polygon([[0,0], [side, 0], [side/2,sqrt(3)*side/2]]);
}

/*
 * Connector Positive
 */
module connector_positive_hex(side,square_basis,edge_width) {
    module _connector_positive() {
        for ( i = [0 : side-1] ) {
            translate([square_basis*(i+1)-square_basis/2,0,0]) rotate([0,0,90]) center_connector_positive(side);
        }
        if (side > 1) {
            for ( i = [1 : side-1] ) {
                translate([square_basis*i,0,0]) rotate([0,0,90]) joint_connector_positive(side);
            }
        }
    }
    _connector_positive();
    translate([square_basis*side,0,0]) rotate([0,0,120]) _connector_positive();
    rotate([0,0,-120]) mirror([1,0,0]) _connector_positive();
}

/*
 * Connector Negative
 */
module connector_negative_hex(side,square_basis,edge_width) {
    module _connector_negative() {
        for ( i = [0 : side-1] ) {
            if (i > 0 && i < (side - 1)) { // Prevents a connector at start and end
                translate([square_basis*(i+1)-square_basis/2,0,0]) rotate([0,0,90]) center_connector_negative(side, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT);
            }
        }
        if (side > 1) {
            for ( i = [1 : side-1] ) {
                translate([square_basis*i,0,0]) rotate([0,0,90]) joint_connector_negative(side);
            }
        }
        if (MAGNETS == "flex_magnetic") {
           flex_magnetic_hex(square_basis, MAGNET_HOLE);
        }

    }
    _connector_negative();
    translate([square_basis*side,0,0]) rotate([0,0,120]) _connector_negative();
    translate([square_basis*side,0,0]) rotate([0,0,120]) translate([square_basis*side,0,0]) rotate([0,0,120]) _connector_negative();
}

/*
 * Plain base exterior
 */
module plain_hex(side,square_basis,edge_width) {
    difference() {
        plain_hex_positive(side,square_basis);
        edge = LOCK == "dragonlock" ? square_basis/2 : edge_width;
        plain_hex_negative(side,square_basis,edge);
    }
}

module plain_hex_positive(side,square_basis) {
    difference() {
        hull() {
            translate([0,0,0.4]) equilateral_triangle(square_basis*side, 6-.39);
            difference() {
                translate([0,0,0]) equilateral_triangle(square_basis*side, 1);
                translate([-1, -1, -1]) cube([square_basis*side+2,1.5,2]);
                translate([square_basis*side,0,0]) rotate([0,0,120]) translate([-1, -1, -1]) cube([square_basis*side+2,1.5,2]);
                rotate([0,0,-120]) mirror([1,0,0]) translate([-1, -1, -1]) cube([square_basis*side+2,1.5,2]);
            }
        }
    }
}

module plain_hex_negative(side,square_basis,edge_width) {
    difference() {
      translate([0,0,-1]) equilateral_triangle(square_basis*side, 8);
      translate([-1, -1, -2]) cube([square_basis*side+2,edge_width+1,10]);
      translate([square_basis*side,0,0]) rotate([0,0,120]) translate([-1, -1, -2]) cube([square_basis*side+2,edge_width+1,10]);
      rotate([0,0,-120]) mirror([1,0,0]) translate([-1, -1, -2]) cube([square_basis*side+2,edge_width+1,10]);

      if (CENTER == "true") {
        translate([-5+square_basis*side/2,1,0]) cube([10, square_basis*side-square_basis,6]);
        translate([square_basis*side, 0, 0]) rotate([0,0,120]) translate([-5+square_basis*side/2,1,0]) cube([10, square_basis*side-square_basis,6]);
        rotate([0,0,-120]) mirror([1,0,0]) translate([-5+square_basis*side/2,1,0]) cube([10, square_basis*side-square_basis,6]);
      }
    }
}
