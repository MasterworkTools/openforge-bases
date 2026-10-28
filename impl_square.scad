include <connectors.scad>

/*
 * Connector Positive
 */
module connector_positive_square(x,y,square_basis,edge_width,north=true,south=true,east=true,west=true) {
    for ( i = [0 : y-1] ) {
        if(west) {
            translate([0,square_basis*(i+1)-square_basis/2,0]) center_connector_positive(y);
        }
        if(east) {
            translate([square_basis*x,square_basis*(i+1)-square_basis/2,0]) rotate([0,0,180]) center_connector_positive(y);
        }
    }
    if (y > 1) {
        for ( i = [1 : y-1] ) {
            if(west) {
                translate([0,square_basis*i,0]) joint_connector_positive(y);
            }
            if(east) {
                translate([square_basis*x,square_basis*i,0]) rotate([0,0,180]) joint_connector_positive(y);
            }
        }
    }
    for ( i = [0 : x-1] ) {
        if(south) {
            translate([square_basis*(i+1)-square_basis/2,0,0]) rotate([0,0,90]) center_connector_positive(x);
        }
        if(north) {
            translate([square_basis*(i+1)-square_basis/2,square_basis*y,0]) rotate([0,0,-90]) center_connector_positive(x);
        }
    }
    if (x > 1) {
        for ( i = [1 : x-1] ) {
            if(south) {
                translate([square_basis*i,0,0]) rotate([0,0,90]) joint_connector_positive(y);
            }
            if(north) {
                translate([square_basis*i,square_basis*y,0]) rotate([0,0,-90]) joint_connector_positive(y);
            }
        }
    }
}

module connector_positive_square_notch(x,y,square_basis,edge_width,north=true,south=true,east=true,west=true) {
    if(NOTCH == "true") {
        connector_positive_square(x,y,square_basis,edge_width,north=north,south=false,east=east,west=false);
        if(south) {
            translate([square_basis*NOTCH_X,0,0]) connector_positive_square(x-NOTCH_X,y-NOTCH_Y,square_basis,edge_width,north=false,south=true,east=false,west=false);
            translate([0,square_basis*NOTCH_Y,0]) connector_positive_square(NOTCH_X,NOTCH_Y,square_basis,edge_width,north=false,south=true,east=false,west=false);
        }
        if(west) {
            translate([square_basis*NOTCH_X,0,0]) connector_positive_square(NOTCH_X,NOTCH_Y,square_basis,edge_width,north=false,south=false,east=false,west=true);
            translate([0,square_basis*NOTCH_Y,0]) connector_positive_square(x-NOTCH_X,y-NOTCH_Y,square_basis,edge_width,north=false,south=false,east=false,west=true);
        }
    } else {
        connector_positive_square(x,y,square_basis,edge_width,north,south,east,west);
    }
}

/*
 * Connector Negative
 */
module connector_negative_square(x,y,square_basis,edge_width,north=true,south=true,east=true,west=true, priority=PRIORITY, lock=LOCK, magnets=MAGNETS, magnet_hole=MAGNET_HOLE, magnet_height=MAGNET_HEIGHT, height=HEIGHT) {
    for ( i = [0 : y-1] ) {
        if(west) {
            translate([0,square_basis*(i+1)-square_basis/2,0]) center_connector_negative(y, priority, lock, magnets, magnet_hole, magnet_height, height=height);
        }
        if(east) {
            translate([square_basis*x,square_basis*(i+1)-square_basis/2,0]) rotate([0,0,180]) center_connector_negative(y, priority, lock, magnets, magnet_hole, magnet_height, height=height);
        }
    }
    if (y > 1) {
        for ( i = [0 : ceil(y)-2] ) {
            if(west) {
                translate([0,square_basis*(i+1),0]) joint_connector_negative(y, height=height, lock=lock);
            }
            if(east) {
                translate([square_basis*x,square_basis*(i+1),0]) rotate([0,0,180]) joint_connector_negative(y, height=height, lock=lock);
            }
        }
    }
    for ( i = [0 : x-1] ) {
        if(south) {
            translate([square_basis*(i+1)-square_basis/2,0,0]) rotate([0,0,90]) center_connector_negative(x, priority, lock, magnets, magnet_hole, magnet_height, height=height);
        }
        if(north) {
            translate([square_basis*(i+1)-square_basis/2,square_basis*y,0]) rotate([0,0,-90]) center_connector_negative(x, priority, lock, magnets, magnet_hole, magnet_height, height=height);
        }
    }
    if (x > 1) {
        for ( i = [0 : ceil(x)-2] ) {
            if(south) {
                translate([square_basis*(i+1),0,0]) rotate([0,0,90]) joint_connector_negative(y, height=height, lock=lock);
            }
            if(north) {
                translate([square_basis*(i+1),square_basis*y,0]) rotate([0,0,-90]) joint_connector_negative(y, height=height, lock=lock);
            }
        }
    }
}

module connector_negative_square_notch(x,y,square_basis,edge_width,north=true,south=true,east=true,west=true) {
    if(NOTCH == "true") {
        connector_negative_square(x,y,square_basis,edge_width,north=north,south=false,east=east,west=false);
        if(south) {
            translate([square_basis*NOTCH_X,0,0]) connector_negative_square(x-NOTCH_X,y-NOTCH_Y,square_basis,edge_width,north=false,south=true,east=false,west=false);
            translate([0,square_basis*NOTCH_Y,0]) connector_negative_square(NOTCH_X,NOTCH_Y,square_basis,edge_width,north=false,south=true,east=false,west=false);
        }
        if(west) {
            translate([square_basis*NOTCH_X,0,0]) connector_negative_square(NOTCH_X,NOTCH_Y,square_basis,edge_width,north=false,south=false,east=false,west=true);
            translate([0,square_basis*NOTCH_Y,0]) connector_negative_square(x-NOTCH_X,y-NOTCH_Y,square_basis,edge_width,north=false,south=false,east=false,west=true);
        }
    } else {
        connector_negative_square(x,y,square_basis,edge_width,north,south,east,west);
    }
}

/*
 * Plain base exterior
 */
module plain_square(x,y,square_basis,edge_width) {
    difference() {
        plain_square_positive(x,y,square_basis);
        edge = LOCK == "dragonlock" ? square_basis/2 : edge_width;
        plain_square_negative(x,y,square_basis,edge);
    }
}

module plain_square_positive(x,y,square_basis) {
    difference() {
        hull() {
            translate([0,0,0.4]) cube([square_basis*x, square_basis*y, HEIGHT-.39]);
            translate([0.25,0.25,0]) cube([square_basis*x-.5, square_basis*y-.5, 1]);
        }
        if(NOTCH == "true") {
            translate([-1,-1,-1]) cube([square_basis*NOTCH_X+1, square_basis*NOTCH_Y+1, 8]);
            hull() {
                translate([-1,-1,0]) cube([square_basis*NOTCH_X+1, square_basis*NOTCH_Y+1, .4]);
                translate([-1,-1,-0.01]) cube([square_basis*NOTCH_X+1.25, square_basis*NOTCH_Y+1.25, 0.01]);
            }
        }
    }
}

module plain_square_negative(x,y,square_basis,edge_width) {
    difference() {
        intersection() {
            translate([edge_width,edge_width,0]) translate([1,1,-1]) cube([square_basis*x-((edge_width+1)*2),square_basis*y-((edge_width+1)*2),HEIGHT+2]);
            difference() {
                translate([edge_width,edge_width,0]) translate([1,1,-1]) cube([square_basis*x-((edge_width+1)*2),square_basis*y-((edge_width+1)*2),HEIGHT+2]);
                if(NOTCH == "true") {
                    translate([0,0,0.4]) cube([square_basis*NOTCH_X+edge_width+1, square_basis*NOTCH_Y+edge_width+1, HEIGHT]);
                    translate([0.25,.25,0]) cube([square_basis*NOTCH_X+edge_width+1-.5, square_basis*NOTCH_Y+edge_width+1-.5, .4]);
                }
            }
        }
        if (CENTER == "grid") {
            for ( i = [2 : 2 : y-1] ) {
                translate([0,(i-.125)*square_basis,-2]) cube([square_basis*x,square_basis/4,HEIGHT+4]);
            }
            for ( i = [2 : 2 : x-1] ) {
                translate([(i-.125)*square_basis,0,-2]) cube([square_basis/4,square_basis*y,HEIGHT+4]);
            }
        } else if (CENTER == "cube") {
            translate([0,(-.125)*square_basis,-2]) cube([square_basis*x,square_basis*y,HEIGHT+4]);
        }
    }
}
