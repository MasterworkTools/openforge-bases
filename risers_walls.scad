include <impl_wall.scad>

/* [Base Tile Size] */
// How many squares on the X axis
x = 2; //[2,3,4,5,6,7,8]
// How tall on the Z axis in half square increments
z = 4; //[1,2,3,4,6,7,8,9]
// How tall is the tile in mm on the Z axis
HEIGHT = 6; // 6 is default
// Add another half square of wall to the end (useful behind a corner).
half = false;

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

module riser_wall(x,half,square_basis) {
    tmp_edge_width = MAGNET_HOLE >= 5.55 ? MAGNET_HOLE + 1 : 6.55;
    edge_width = (PRIORITY == "lock" && (x == 1)) || LOCK == "triplex" || LOCK == "openlock" && MAGNETS == "none" || LOCK == "openlock_topless" && MAGNETS == "none" ? tmp_edge_width : square_basis/2;
    h = half ? 0.5 : 0;

    difference() {
        translate([0,-0.25*square_basis_number,0]) cube([(x+h)*square_basis_number, 0.5*square_basis_number, z/2*square_basis_number]);
        for ( i = [1 : z] ) {
            translate([0,0,(i-1)/2*square_basis_number]) connector_wall_negative(x,half,square_basis,edge_width);
        }
        if (z > 4) {
            translate([0,0,height_basis[keyLookup(height_basis, ["high"])][1]]) openlock_sidelock_negative();
            translate([(x+h)*square_basis,0,height_basis[keyLookup(height_basis, ["high"])][1]]) rotate([0,0,180])  openlock_sidelock_negative();
        }
        if (z > 3) {
            translate([0,0,height_basis[keyLookup(height_basis, ["medium"])][1]]) openlock_sidelock_negative();
            translate([(x+h)*square_basis,0,height_basis[keyLookup(height_basis, ["medium"])][1]]) rotate([0,0,180])  openlock_sidelock_negative();
        }
        if (z > 1) {
            translate([0,0,height_basis[keyLookup(height_basis, ["low"])][1]]) openlock_sidelock_negative();
            translate([(x+h)*square_basis,0,height_basis[keyLookup(height_basis, ["low"])][1]]) rotate([0,0,180])  openlock_sidelock_negative();
        }
    }
}

MAGNETS = "none";
MAGNET_HOLE = 0;
MAGNET_HEIGHT = 2.6;
TOPLESS = "false";
PRIORITY = "lock";
NOTCH = "false";

function keyLookup (data, key) = search(key, data, num_returns_per_match=1)[0];
basis = [
    ["25mm", 25],
    ["inch", 25.4],
    ["wyloch", 31.75],
    ["drc", 38.1]
];
square_basis_number = basis[keyLookup(basis, [SQUARE_BASIS])][1];
wall_width = 10.2*square_basis_number/25;

height_basis = [
    ["low", 8.9],
    ["medium", 27.9],
    ["high", 46.9]
];

riser_wall(x,half,square_basis_number);
