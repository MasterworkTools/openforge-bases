/* [Base Tile Size] */
// How many squares on the X axis
x = 2; //[2,3,4,5,6,7,8]
// How many squares on the Y axis
y = 2; //[2,3,4,5,6,7,8]
// How tall on the Z axis in half square increments
z = 4; //[1,2,3,4,6,7,8,9]

/* [Square Basis] */
// What is the size in mm of a square?
SQUARE_BASIS = "inch"; // [25mm:25mm - Dwarven Forge/Hirstarts, inch:inch (25.4) - OpenLOCK/Dragonlock/Dungeonworks, wyloch:1 1/4 inch (31.75) - Wyloch, drc:1 1/2 inch (38.1) - Dragon's Rest]

/* [Lock] */
// Dragonlock - connector between squares, pips on either side for stacking
// InfinityLock - connector between squares and in the middle of squares
// OpenLOCK - connector between squares
// OpenLOCK Triplex - connector between squares and in the middle of squares
// OpenLOCK Topless - openlock, but without a top
// Select the type of clip lock
LOCK = "openlock";// [openlock,triplex,infinitylock,dragonlock,none]
// If OpenLock, do we want supports?
SUPPORTS = "true"; // [true, false]

include <impl_curved.scad>

/*
 * Top Level Function
 */
 
module riser_curved(x,y,square_basis) {
    tmp_edge_width = MAGNET_HOLE >= 5.55 ? MAGNET_HOLE + 1 : 6.55;
    edge_width = (PRIORITY == "lock" && (x == 1 || y == 1)) || LOCK == "triplex" || LOCK == "openlock" && MAGNETS == "none" || LOCK == "openlock_topless" && MAGNETS == "none" ? tmp_edge_width : square_basis/2;

    difference() {
        intersection() {
            cube([x*square_basis_number, y*square_basis_number, z/2*square_basis_number]);
            translate([0,0,-1]) scale([x,y,1]) cylinder(200,square_basis,square_basis,$fn=200);
        }
        if(LOCK != "none") {
            for ( i = [1 : z] ) {
                translate([0,0,(i-1)/2*square_basis_number]) connector_negative_curved(x,y,square_basis,edge_width);
            }
        } else {
            translate([-1,-1,-1]) cube([x*square_basis_number+2, y*square_basis_number+2, 7]);
        }
    }
}

module base_curved(x,y,square_basis) {
    difference() {
        intersection() {
            plain_square_positive(x,y,square_basis);
            hull() {
                translate([0,0,0.4]) scale([x,y,1]) cylinder(5.6,square_basis,square_basis,$fn=200);
                translate([0,0,0]) scale([(x-.25/square_basis),(y-0.25/square_basis),1]) cylinder(.4,square_basis,square_basis,$fn=200);
            }
        }
        
        intersection() {
            plain_square_negative(x,y,square_basis,edge_width);
            translate([0,0,-1]) scale([((x*square_basis)-edge_width)/square_basis,((y*square_basis)-edge_width)/square_basis,1]) cylinder(8,square_basis,square_basis,$fn=200);
        }
    }




    difference() {
        union() {
            plain_base_curved(x,y,square_basis,edge_width);
            connector_positive_curved(x,y,square_basis,edge_width) ;
        }
        connector_negative_curved(x,y,square_basis,edge_width) ;
    }
}

MAGNETS = "none";
MAGNET_HOLE = 0;
MAGNET_HEIGHT = 2.6;
PRIORITY = "lock";
NOTCH = "false";
TOPLESS = "false";
HEIGHT = 6;
CURVED_CONCAVE = "false";
CURVED_LARGE = "b";
CURVED_SQUARE = "false";


function keyLookup (data, key) = search(key, data, num_returns_per_match=1)[0];
basis = [
    ["25mm", 25],
    ["inch", 25.4],
    ["wyloch", 31.75],
    ["drc", 38.1],
];
square_basis_number = basis[keyLookup(basis, [SQUARE_BASIS])][1];
wall_width = 10.2*square_basis_number/25;

riser_curved(x,y,square_basis_number);