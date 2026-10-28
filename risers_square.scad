include <impl_square.scad>
/* [Base Riser Size] */
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

module riser_square(x,y,square_basis) {
    tmp_edge_width = MAGNET_HOLE >= 5.55 ? MAGNET_HOLE + 1 : 6.55;
    edge_width = (PRIORITY == "lock" && (x == 1 || y == 1)) || LOCK == "triplex" || LOCK == "openlock" && MAGNETS == "none" || LOCK == "openlock_topless" && MAGNETS == "none" ? tmp_edge_width : square_basis/2;

    difference() {
        cube([x*square_basis_number, y*square_basis_number, z/2*square_basis_number]);
        if(LOCK != "none") {
            for ( i = [1 : z] ) {
                translate([0,0,(i-1)/2*square_basis_number]) connector_negative_square_notch(x,y,square_basis,edge_width);
            }
        } else {
            translate([-1,-1,-1]) cube([x*square_basis_number+2, y*square_basis_number+2, 7]);
        }
    }
}

MAGNETS = "none";
MAGNET_HOLE = 0;
MAGNET_HEIGHT = 2.6;
PRIORITY = "lock";
NOTCH = "false";
TOPLESS = "false";
HEIGHT = 6;


function keyLookup (data, key) = search(key, data, num_returns_per_match=1)[0];
basis = [
    ["25mm", 25],
    ["inch", 25.4],
    ["wyloch", 31.75],
    ["drc", 38.1]
];
square_basis_number = basis[keyLookup(basis, [SQUARE_BASIS])][1];
wall_width = 10.2*square_basis_number/25;

riser_square(x,y,square_basis_number);