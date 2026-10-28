include <impl_square.scad>
// include <connectors.scad>

/*
 * Connector Positive
 */
module connector_positive_diagonal(x,y,diagonal_basis,edge_width,north=true,south=true,east=true,west=true) {
    for ( i = [0 : y-1] ) {
        if(west) {
            translate([0,diagonal_basis*(i+1)-diagonal_basis/2,0]) center_connector_positive(y);
        }
        if(east) {
            translate([diagonal_basis*x,diagonal_basis*(i+1)-diagonal_basis/2,0]) rotate([0,0,180]) center_connector_positive(y);
        }
    }
    if (y > 1) {
        for ( i = [1 : y-1] ) {
            if(west) {
                translate([0,diagonal_basis*i,0]) joint_connector_positive(y);
            }
            if(east) {
                translate([diagonal_basis*x,diagonal_basis*i,0]) rotate([0,0,180]) joint_connector_positive(y);
            }
        }
    }
    for ( i = [0 : x-1] ) {
        if(south) {
            translate([diagonal_basis*(i+1)-diagonal_basis/2,0,0]) rotate([0,0,90]) center_connector_positive(x);
        }
        if(north) {
            translate([diagonal_basis*(i+1)-diagonal_basis/2,diagonal_basis*y,0]) rotate([0,0,-90]) center_connector_positive(x);
        }
    }
    if (x > 1) {
        for ( i = [1 : x-1] ) {
            if(south) {
                translate([diagonal_basis*i,0,0]) rotate([0,0,90]) joint_connector_positive(y);
            }
            if(north) {
                translate([diagonal_basis*i,diagonal_basis*y,0]) rotate([0,0,-90]) joint_connector_positive(y);
            }
        }
    }
}

module connector_positive_diagonal_notch(x,y,diagonal_basis,edge_width,north=true,south=true,east=true,west=true) {
    if(NOTCH == "true") {
        connector_positive_diagonal(x,y,diagonal_basis,edge_width,north=north,south=false,east=east,west=false);
        if(south) {
            translate([diagonal_basis*NOTCH_X,0,0]) connector_positive_diagonal(x-NOTCH_X,y-NOTCH_Y,diagonal_basis,edge_width,north=false,south=true,east=false,west=false);
            translate([0,diagonal_basis*NOTCH_Y,0]) connector_positive_diagonal(NOTCH_X,NOTCH_Y,diagonal_basis,edge_width,north=false,south=true,east=false,west=false);
        }
        if(west) {
            translate([diagonal_basis*NOTCH_X,0,0]) connector_positive_diagonal(NOTCH_X,NOTCH_Y,diagonal_basis,edge_width,north=false,south=false,east=false,west=true);
            translate([0,diagonal_basis*NOTCH_Y,0]) connector_positive_diagonal(x-NOTCH_X,y-NOTCH_Y,diagonal_basis,edge_width,north=false,south=false,east=false,west=true);
        }
    } else {
        connector_positive_diagonal(x,y,diagonal_basis,edge_width,north,south,east,west);
    }
}

/*
 * Connector Negative
 */
module connector_negative_diagonal(x,y,diagonal_basis,edge_width,north=true,south=true,east=true,west=true) {
    for ( i = [0 : y-1] ) {
        if(west) {
            translate([0,diagonal_basis*(i+1)-diagonal_basis/2,0]) center_connector_negative(y, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, height=HEIGHT);
        }
        /*
        if(east) {
            translate([diagonal_basis*x,diagonal_basis*(i+1)-diagonal_basis/2,0]) rotate([0,0,180]) center_connector_negative(y, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, height=HEIGHT);
        }
        */
    }
    if (y > 1) {
        for ( i = [1 : y-1] ) {
            if(west) {
                translate([0,diagonal_basis*i,0]) joint_connector_negative(y, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, height=HEIGHT);
            }
            /*
            if(east) {
                translate([diagonal_basis*x,diagonal_basis*i,0]) rotate([0,0,180]) joint_connector_negative(y, , height=HEIGHT);
            }
            */
        }
    }
    for ( i = [0 : x-1] ) {
        if(south) {
            translate([diagonal_basis*(i+1)-diagonal_basis/2,0,0]) rotate([0,0,90]) center_connector_negative(x, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, height=HEIGHT);
        }
        /*
        if(north) {
            translate([diagonal_basis*(i+1)-diagonal_basis/2,diagonal_basis*y,0]) rotate([0,0,-90]) center_connector_negative(x, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, height=HEIGHT);
        }
        */
    }
    if (x > 1) {
        for ( i = [1 : x-1] ) {
            if(south) {
                translate([diagonal_basis*i,0,0]) rotate([0,0,90]) joint_connector_negative(y, height=HEIGHT);
            }
            /*
            if(north) {
                translate([diagonal_basis*i,diagonal_basis*y,0]) rotate([0,0,-90]) joint_connector_negative(y, height=HEIGHT);
            }
            */
        }
    }
}

module connector_negative_diagonal_notch(x,y,diagonal_basis,edge_width,south=true,west=true) {
    if(NOTCH == "true") {
        connector_negative_diagonal(x,y,diagonal_basis,edge_width,north=false,south=false,east=false,west=false);
        if(south) {
            translate([diagonal_basis*NOTCH_X,0,0]) connector_negative_diagonal(x-NOTCH_X,y-NOTCH_Y,diagonal_basis,edge_width,north=false,south=true,east=false,west=false);
            translate([0,diagonal_basis*NOTCH_Y,0]) connector_negative_diagonal(NOTCH_X,NOTCH_Y,diagonal_basis,edge_width,north=false,south=true,east=false,west=false);
        }
        if(west) {
            translate([diagonal_basis*NOTCH_X,0,0]) connector_negative_diagonal(NOTCH_X,NOTCH_Y,diagonal_basis,edge_width,north=false,south=false,east=false,west=true);
            translate([0,diagonal_basis*NOTCH_Y,0]) connector_negative_diagonal(x-NOTCH_X,y-NOTCH_Y,diagonal_basis,edge_width,north=false,south=false,east=false,west=true);
        }
    } else {
        connector_negative_diagonal(x,y,diagonal_basis,edge_width,false,south,false,west);
    }
}

/*
 * Plain base exterior
 */

module plain_diagonal(x,y,diagonal_basis,lock,edge_width) {
    hyp = sqrt(diagonal_basis*x*diagonal_basis*x+diagonal_basis*y*diagonal_basis*y);
    plain_diagonal_positive(x,y,diagonal_basis,lock,hyp,edge_width);
    plain_diagonal_negative(x,y,diagonal_basis,lock,hyp);
}

module plain_diagonal_positive(x,y,diagonal_basis,lock,hyp,edge_width) {
    difference() {
        intersection() {
            plain_square_positive(x,y,diagonal_basis);
            translate([x*diagonal_basis,0,0]) rotate([0,0,atan(x/y)]) {
                translate([0,0,0.4]) cube([wall_width/2,hyp,5.6]);
                translate([0.25,0.25,0]) cube([wall_width/2-.5,hyp-.5,.4]);
                mirror([1,0,0]) cube([hyp,hyp,6]);
            }
        }
        if (lock == "dragonlock") {
            if (x > 1 && y > 1) {
                translate([diagonal_basis/2,diagonal_basis/2,-1]) cube([diagonal_basis*(x-1), diagonal_basis*(y-1),8]);
                dragonlock_nub(diagonal_basis);
                translate([diagonal_basis*x,0,0]) rotate([0,0,90]) dragonlock_nub(diagonal_basis);
                difference() {
                    translate([0,diagonal_basis*y,0]) rotate([0,0,270]) dragonlock_nub(diagonal_basis);
                    translate([x*diagonal_basis+diagonal_basis*.2,0,0]) rotate([0,0,atan(x/y)-90]) mirror([1,0,0]) cube([hyp* 1.5,hyp*1.5,6]);
                }
                    
            }
        } else {
            plain_square_negative(x,y,diagonal_basis,edge_width);
        }
    }
}

module plain_diagonal_negative(x,y,diagonal_basis,lock,hyp) {
    intersection() {
        translate([x*diagonal_basis,0,0]) rotate([0,0,atan(x/y)]) {
            hull() {
                translate([0,0,0.4]) cube([wall_width/2,hyp,56]);
                translate([0,0.25,0])cube([wall_width/2-.25,hyp-.5,0.4]);
            }
            mirror([1,0,0]) cube([wall_width/2,hyp,6]);
        }
        difference() {
            hull() {
                translate([0,0,0.4]) cube([diagonal_basis*x, diagonal_basis*y, 5.6]);
                translate([0.25,0.25,0]) cube([diagonal_basis*x-.5, diagonal_basis*y-.5, .4]);
            }
            if(lock == "dragonlock" && x > 1 && y > 1) {
                difference() {
                    translate([0,diagonal_basis*(y-1),0]) dragonlock_nub();
                    translate([x*diagonal_basis+diagonal_basis*.2,0,0]) rotate([0,0,atan(x/y)-90]) mirror([1,0,0]) cube([hyp* 1.5,hyp*1.5,6]);
                }
                difference() {
                    translate([diagonal_basis*x,diagonal_basis,0]) rotate([0,0,180]) dragonlock_nub();
                    translate([0,y*diagonal_basis+diagonal_basis*.2,0]) rotate([0,0,atan(x/y)+180]) mirror([1,0,0]) cube([hyp* 1.5,hyp*1.5,6]);
                }
            }
        }
    }
}

/*
module plain_diagonal(x,y,square_basis,lock,edge_width) {
    hyp = sqrt(square_basis*x*square_basis*x+square_basis*y*square_basis*y);
    difference() {
        intersection() {
            plain_square_positive(x,y,square_basis);
            translate([x*square_basis,0,0]) rotate([0,0,atan(x/y)]) {
                translate([0,0,0.4]) cube([wall_width/2,hyp,5.6]);
                translate([0.25,0.25,0]) cube([wall_width/2-.5,hyp-.5,.4]);
                mirror([1,0,0]) cube([hyp,hyp,6]);
            }
        }
        if (lock == "dragonlock") {
            if (x > 1 && y > 1) {
                translate([square_basis/2,square_basis/2,-1]) cube([square_basis*(x-1), square_basis*(y-1),8]);
                dragonlock_nub(square_basis);
                translate([square_basis*x,0,0]) rotate([0,0,90]) dragonlock_nub(square_basis);
                difference() {
                    translate([0,square_basis*y,0]) rotate([0,0,270]) dragonlock_nub(square_basis);
                    translate([x*square_basis+square_basis*.2,0,0]) rotate([0,0,atan(x/y)-90]) mirror([1,0,0]) cube([hyp* 1.5,hyp*1.5,6]);
                }
                    
            }
        } else {
            plain_square_negative(x,y,square_basis,edge_width);
        }
    }
    intersection() {
        translate([x*square_basis,0,0]) rotate([0,0,atan(x/y)]) {
            hull() {
                translate([0,0,0.4]) cube([wall_width/2,hyp,56]);
                translate([0,0.25,0])cube([wall_width/2-.25,hyp-.5,0.4]);
            }
            mirror([1,0,0]) cube([wall_width/2,hyp,6]);
        }
        difference() {
            hull() {
                translate([0,0,0.4]) cube([square_basis*x, square_basis*y, 5.6]);
                translate([0.25,0.25,0]) cube([square_basis*x-.5, square_basis*y-.5, .4]);
            }
            if(lock == "dragonlock" && x > 1 && y > 1) {
                difference() {
                    translate([0,square_basis*(y-1),0]) dragonlock_nub();
                    translate([x*square_basis+square_basis*.2,0,0]) rotate([0,0,atan(x/y)-90]) mirror([1,0,0]) cube([hyp* 1.5,hyp*1.5,6]);
                }
                difference() {
                    translate([square_basis*x,square_basis,0]) rotate([0,0,180]) dragonlock_nub();
                    translate([0,y*square_basis+square_basis*.2,0]) rotate([0,0,atan(x/y)+180]) mirror([1,0,0]) cube([hyp* 1.5,hyp*1.5,6]);
                }
            }
        }
    }
}
*/