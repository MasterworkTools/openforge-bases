/* [Base Tile Size] */
// What is the radius of the outer diameter
x = 4; //[1,2,3,4,5,6,7,8]
// What is the radius of the inner diameter (must be smaller than x)
cut = 2; //[1,2,3,4,5,6,7,8]
// What amount of angle does the base cover
angle = 90; //[90,45,22.5,11.25]
// How many locks in the outer diameter
od_radial_connectors = 3; //[0,1,3,7]
// How many locks in the inner diameter
id_radial_connectors = 3; //[0,1,3]
// How tall is the tile in mm on the Z axis
HEIGHT = 6; // 6 is default

/* [Square Basis] */
// What is the size in mm of a square?
SQUARE_BASIS = "inch"; // [25mm:25mm - Dwarven Forge/Hirstarts, inch:inch - OpenLOCK/Dragonlock/Dungeonworks, wyloch:1 1/4 inch - Wyloch]

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

/* [Magnets] */
// Use magnets or not.
MAGNETS = "flex_magnetic"; // [magnetic, flex_magnetic,snap_magnetic, none]
// Size of hole for magnet.  6 works well for 5mm buckyball style magnets.  0 to eliminate.
MAGNET_HOLE = 6;
// Size of the insert slot for magnet. Only applicable to snap_magnetic. Measure your magnets with a caliper.
MAGNET_HEIGHT = 2.6; //.01
ID_MAGNETS = "false"; // [true, false]
OD_MAGNETS = "true"; // [true, false]

/* [Priority] */
// Do you want lock or magnets to win when the two conflict
PRIORITY = "magnets"; // [lock,magnets]

include <impl_curved_radial.scad>

/*
 * Top Level Function
 */
module base_curved(x,cut,angle,square_basis) {
    tmp_edge_width = MAGNET_HOLE >= 5.55 ? MAGNET_HOLE + 1 : 6.55;
    edge_width = LOCK == "triplex" ? tmp_edge_width : square_basis/2 ;

    difference() {
        union() {
            plain_base_curved_radial(x, cut, angle, square_basis, edge_width);
        }
        connector_negative_curved_radial(x, cut, angle, square_basis, edge_width, id_radial_connectors, od_radial_connectors, id_magnets=ID_MAGNETS=="true", od_magnets=OD_MAGNETS=="true");
    }
}

function keyLookup (data, key) = search(key, data, num_returns_per_match=1)[0];

NOTCH = "false";

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
    color("Grey") base_curved(x,cut,angle,square_basis_number);
}
