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
// If OpenLock, do we want supports?
SUPPORTS = "true"; // [true, false]
// Do you want connectors around the curve
RADIAL_CONNECTORS = "true"; // [true, false]

/* [Magnets] */
// Use magnets or not.
MAGNETS = "flex_magnetic"; // [magnetic, flex_magnetic,snap_magnetic]
// Size of hole for magnet.  6 works well for 5mm buckyball style magnets.  0 to eliminate.
MAGNET_HOLE = 6;
// Size of the insert slot for magnet. Only applicable to snap_magnetic. Measure your magnets with a caliper.
MAGNET_HEIGHT = 2.6; //.01
CURVED_MAGNETS = "false"; // [true, false]

/* [Priority] */
// Do you want lock or magnets to win when the two conflict
PRIORITY = "lock"; // [lock,magnets]

/* [Curved Options] */
// curvedlarge - 6x6 and 8x8 are made of 3 tiles, a, b & c.  In some special cases, there is ac (a+c) and ax/cx for 8x which go on either side of ac  Will be ignored if sizes aren't 6x6 or 8x8
CURVED_LARGE = "complete"; // [complete,a,b,c,ac,ax,cx]

/* [Notch Options] */
// Removes a square from the tile of notch_x by notch_y
NOTCH = "false"; // [true,false]
NOTCH_X = 2; // [1,2,3]
NOTCH_Y = 2; // [1,2,3]

/* [Center Options] */
// Keep center clear, fill it in, or do a grid every 2x
CENTER = "false"; // [grid, cube, false]

include <impl_curved.scad>

/*
 * Top Level Function
 */
module base_curved(x,y,square_basis) {
    tmp_edge_width = MAGNET_HOLE >= 5.55 ? MAGNET_HOLE + 1 : 6.55;
    edge_width = LOCK == "triplex" ? tmp_edge_width : square_basis/2 ;

    odcons = [
        [1, 0],
        [2, 3],
        [3, 3],
        [4, 3],
        [6, 7]
    ];

    difference() {
        union() {
            plain_base_curved(x,y,square_basis,edge_width);
            connector_positive_curved(x,y,square_basis,edge_width) ;
        }
        
        od_connectors = RADIAL_CONNECTORS=="true" ? odcons[keyLookup(odcons, [x])][1] : 0;
        connector_negative_curved(x,y,square_basis,edge_width,od_connectors=od_connectors,curved_magnets=CURVED_MAGNETS=="true") ;
    }
}

function keyLookup (data, key) = search(key, data, num_returns_per_match=1)[0];

basis = [
    ["25mm", 25],
    ["inch", 25.4],
    ["wyloch", 31.75],
    ["drc", 38.1]
];
square_basis_number = basis[keyLookup(basis, [SQUARE_BASIS])][1];
wall_width = 12.7*square_basis_number/25;

// Compatability
valid_dragonlock_basis = (SQUARE_BASIS == "inch");
valid_infinitylock_basis = (SQUARE_BASIS == "inch");

if (LOCK == "dragonlock" && !valid_dragonlock_basis) {
    echo("ERROR: dragonlock is only compatible with inch basis");
} else if (LOCK == "infinitylock" && !valid_infinitylock_basis) {
    echo("ERROR: infinitylock is only compatible with inch basis");
} else {
    color("Grey") base_curved(x,y,square_basis_number);
}
