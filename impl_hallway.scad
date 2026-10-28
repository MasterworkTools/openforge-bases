include <connectors.scad>

/*
 * Connector Positive
 */
module connector_positive_hallway(x,y,square_basis,edge_width,north=true,south=true,east=true,west=true) {
    for ( i = [0 : y-1] ) {
        if(west) {
            translate([0,square_basis*(i+1)-square_basis/2,0]) center_connector_positive(y);
        }
        if(east) {
            translate([square_basis*(x+1),square_basis*(i+1)-square_basis/2,0]) rotate([0,0,180]) center_connector_positive(y);
        }
    }
    if (y > 1) {
        for ( i = [1 : y-1] ) {
            if(west) {
                translate([0,square_basis*i,0]) joint_connector_positive(y);
            }
            if(east) {
                translate([square_basis*(x+1),square_basis*i,0]) rotate([0,0,180]) joint_connector_positive(y);
            }
        }
    }
    for ( i = [0 : x-1] ) {
        if(south) {
            translate([square_basis*(i+1.5)-square_basis/2,0,0]) rotate([0,0,90]) center_connector_positive(x);
        }
        if(north) {
            translate([square_basis*(i+1.5)-square_basis/2,square_basis*y,0]) rotate([0,0,-90]) center_connector_positive(x);
        }
    }
    if (x > 1) {
        for ( i = [1 : x-1] ) {
            if(south) {
                translate([square_basis*(i+.5),0,0]) rotate([0,0,90]) joint_connector_positive(y);
            }
            if(north) {
                translate([square_basis*(i+.5),square_basis*y,0]) rotate([0,0,-90]) joint_connector_positive(y);
            }
        }
    }
}

/*
 * Connector Negative
 */
module connector_negative_hallway(x,y,square_basis,edge_width,north=true,south=true,east=true,west=true) {
    for ( i = [0 : y-1] ) {
        if(west) {
            translate([0,square_basis*(i+1)-square_basis/2,0]) center_connector_negative(y, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT);
        }
        if(east) {
            translate([square_basis*(x+1),square_basis*(i+1)-square_basis/2,0]) rotate([0,0,180]) center_connector_negative(y, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT);
        }
    }
    if (y > 1) {
        for ( i = [1 : y-1] ) {
            if(west) {
                translate([0,square_basis*i,0]) joint_connector_negative(y);
            }
            if(east) {
                translate([square_basis*(x+1),square_basis*i,0]) rotate([0,0,180]) joint_connector_negative(y);
            }
        }
    }
    for ( i = [0 : x-1] ) {
        if(south) {
            translate([square_basis*(i+1.5)-square_basis/2,0,0]) rotate([0,0,90]) center_connector_negative(x, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT);
        }
        if(north) {
            translate([square_basis*(i+1.5)-square_basis/2,square_basis*y,0]) rotate([0,0,-90]) center_connector_negative(x, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT);
        }
    }
    if (x > 1) {
        for ( i = [1 : x-1] ) {
            if(south) {
                translate([square_basis*(i+.5),0,0]) rotate([0,0,90]) joint_connector_negative(y);
            }
            if(north) {
                translate([square_basis*(i+.5),square_basis*y,0]) rotate([0,0,-90]) joint_connector_negative(y);
            }
        }
    }
}


/*
 * Plain base exterior
 */
module plain_hallway(x,y,square_basis,edge_width) {
    difference() {
        plain_hallway_positive(x,y,square_basis);
        edge = LOCK == "dragonlock" ? square_basis/2 : edge_width;
        plain_hallway_negative(x,y,square_basis,edge);
    }
}

module plain_hallway_positive(x,y,square_basis) {
    difference() {
        hull() {
            translate([0,0,0.4]) cube([square_basis*x, square_basis*y, 6-.39]);
            translate([0.25,0.25,0]) cube([square_basis*x-.5, square_basis*y-.5, 1]);
        }
    }
}

module plain_hallway_negative(x,y,square_basis,edge_width) {
    difference() {
        intersection() {
            translate([edge_width,edge_width,0]) translate([1,1,-1]) cube([square_basis*x-((edge_width+1)*2),square_basis*y-((edge_width+1)*2),8]);
            difference() {
                translate([edge_width,edge_width,0]) translate([1,1,-1]) cube([square_basis*x-((edge_width+1)*2),square_basis*y-((edge_width+1)*2),8]);
            }
        }
    }
}
