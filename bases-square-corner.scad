/* [Base Tile Size] */
// How many squares on the X axis
x = 2; //[2,3,4,5,6,7,8]
// How many squares on the Y axis
y = 2; //[2,3,4,5,6,7,8]
// How tall is the tile in mm on the Z axis
HEIGHT = 6; // 6 is default

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
// If OpenLock remove top of openlock bays
TOPLESS = "true"; // [true, false]
// If Openlock, do we want supports?
SUPPORTS = "true"; // [true, false]
// Only use clips on the wall facing side
WALL_LOCKS = "false"; // [true, false]


 /* [Magnets] */
// Use magnets or not.
MAGNETS = "flex_magnetic"; // [magnetic,flex_magnetic,snap_magnetic,none]
// Size of hole for magnet.  6 works well for 5mm buckyball style magnets.
MAGNET_HOLE = 6;
// Size of the insert slot for magnet. Only applicable to snap_magnetic. Measure your magnets with a caliper.
MAGNET_HEIGHT = 2.6; //.01

/* [Priority] */
// Do you want lock or magnets to win when the two conflict
PRIORITY = "lock"; // [lock,magnets]




include <impl_square.scad>

/*
 * Top Level Function
 */
module base_square(x,y,square_basis) {
    tmp_edge_width = MAGNET_HOLE >= 5.55 ? MAGNET_HOLE + 1 : 6.55;
    electronics = (x <= 2 || y <= 2) && ELECTRONICS == "true";
    edge_width = ((PRIORITY == "lock" && (x == 1 || y == 1)) || LOCK == "triplex" || LOCK == "openlock" && MAGNETS == "none" || LOCK == "openlock_topless" && MAGNETS == "none") || electronics ? tmp_edge_width : square_basis/2 ;

    difference() {
        union() {
            plain_square(x-.5,y-.5,square_basis,edge_width);
            connector_positive_square(x-.5,y-.5,square_basis,edge_width);
        }
        if (WALL_LOCKS == "true") {
            connector_negative_square(x-.5,y-.5,square_basis,edge_width,north=false,east=false);
            connector_negative_square(x-.5,y-.5,square_basis,edge_width,south=false,west=false,magnets="none",priority="lock") ;
        } else {
            connector_negative_square(x-.5,y-.5,square_basis,edge_width);
        }
    }
}

function keyLookup (data, key) = search(key, data, num_returns_per_match=1)[0];

NOTCH = "false";
ELECTRONICS = "false";
CENTER = "false";

basis = [
    ["25mm", 25],
    ["inch", 25.4],
    ["wyloch", 31.75],
    ["drc", 38.1]
];
square_basis_number = basis[keyLookup(basis, [SQUARE_BASIS])][1];
wall_width = 10.2*square_basis_number/25;

// Compatability
valid_dragonlock_basis = (SQUARE_BASIS == "inch");
valid_infinitylock_basis = (SQUARE_BASIS == "inch");

if (LOCK == "dragonlock" && !valid_dragonlock_basis) {
    echo("ERROR: dragonlock is only compatible with inch basis");
} else if (LOCK == "infinitylock" && !valid_infinitylock_basis) {
    echo("ERROR: infinitylock is only compatible with inch basis");
} else {
    color("Grey") base_square(x,y,square_basis_number);
}

//plain_base(x,y,square_basis_number,shape,7);