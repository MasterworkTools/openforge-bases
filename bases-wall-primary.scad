/* [Texture] */
// Select a texture.
TEXTURE = "Plain"; // [Dungeon Stone, Cut-Stone, Towne, Plain, Rough Stone, Facade - Ground Level, Facade - Ground Level -  Door, Facade - Upper Level, Facade - Upper Level - Chimney, Necromancer's Ossuary]

/* [Base Wall Size] */
// What is the wall size
SIZE = "2x (A)"; //[2x (A), 1x (IA), 1.5x (BA), 3x (D), 4x (Q)]
// BA doesn't have symmetry, allows you to mirror
MIRROR_BA = "false"; //[true, false]

/* [Square Basis] */
// What is the size in mm of a square?
SQUARE_BASIS = "inch"; // [25mm:25mm - Dwarven Forge/Hirstarts, inch:inch (25.4) - OpenLOCK/Dragonlock/Dungeonworks, wyloch:1 1/4 inch (31.75) - Wyloch, drc:1 1/2 inch (38.1) - Dragon's Rest]

/* [Lock] */
// Dragonlock - connector between squares, pips on either side for stacking
// InfinityLock - connector between squares and in the middle of squares
// OpenLOCK - connector between squares and in the middle of squares
// Topless - openlock only.  No top, so no bridging
// Supports - openlock only.  Supports in the front of the openlock bay or not.
// Select the type of clip lock
LOCK = "openlock";// [openlock,infinitylock,dragonlock,none]
// If OpenLock remove top of openlock bays
TOPLESS = "true"; // [true, false]
// If OpenLock open connector from either side of wall
DUAL = "false"; // [true, false]
// If OpenLock, do we want supports?
SUPPORTS = "true"; // [true, false]

 /* [Magnets] */
// Magnet Hole: Size of hole for magnet.  6 works well for 5mm buckyball style magnets.
// If you want old school bases with only one connector in the middle and no magnets, set this to 0
// Magnets: Use magnets or not.
MAGNETS = "flex_magnetic"; // [magnetic, flex_magnetic, none]
// Size of hole for magnet.  6: 5mm buckyball.  0: removes
MAGNET_HOLE = 6;

include <connectors.scad>

module plain_wall(x,square_basis,edge_width) {
    translate([-x*square_basis/2,-square_basis/4,0]) cube([x*square_basis,square_basis/2,6]);
}

module textured_wall(x,square_basis,edge_width) {
    if (TEXTURE == "Plain") {
        plain_wall(x, square_basis, edge_width);
    } else {
        fn = str(texture_file, ".blank.", size_file, ".stl");
        import(fn, convexity=5);
    }
}

/*
 * Top Level Function
 */
module base_wall_primary(x,square_basis) {
    tmp_edge_width = MAGNET_HOLE >= 5.55 ? MAGNET_HOLE + 1 : 6.55;
    electronics = (x <= 2) && ELECTRONICS == "true";
    edge_width = ((PRIORITY == "lock" && (x == 1)) || LOCK == "triplex" || LOCK == "openlock" && MAGNETS == "none" || LOCK == "openlock_topless" && MAGNETS == "none") || electronics ? tmp_edge_width : square_basis/2 ;

    if(x == 1.5) {
        difference() {
            union() {
                textured_wall(x,square_basis,edge_width);
                if (MIRROR_BA == "false") {
                    translate([-x*square_basis/2,-square_basis/4,0]) connector_positive_strip(x,  square_basis, edge_width, right=false);
                } else {
                    translate([x*square_basis/2,-square_basis/4,0]) mirror([1,0,0]) connector_positive_strip(x,  square_basis, edge_width, left=false);
                }
            }
            if (MIRROR_BA == "false") {
                translate([-x*square_basis/2,-square_basis/4,0]) connector_negative_strip(x, square_basis, edge_width, right=false);
            } else {
                translate([x*square_basis/2,-square_basis/4,0]) mirror([1,0,0]) connector_negative_strip(x, square_basis, edge_width, right=false);
            }
            if (LOCK == "none") { //covers the weird edge case of BA magnetic
                translate([x*square_basis/2,-square_basis/4,0]) mirror([1,0,0]) connector_negative_strip(x, square_basis, edge_width, right=false);
            }
        }
    } else {
        difference() {
            union() {
                textured_wall(x,square_basis,edge_width);
                translate([-x*square_basis/2,-square_basis/4,0]) connector_positive_strip(x, square_basis, edge_width);
            }
            translate([-x*square_basis/2,-square_basis/4,0]) connector_negative_strip(x, square_basis, edge_width);
        }
    }
}

ELECTRONICS = "false";
HEIGHT = 6;
NOTCH = "false";
CENTER = "none";
PRIORITY = "lock";


function keyLookup (data, key) = search(key, data, num_returns_per_match=1)[0];

texture_files = [
    ["Dungeon Stone", "dungeon_stone"],
    ["Cut-Stone", "cut-stone"],
    ["Towne", "towne"],
    ["Plain", "plain"],
    ["Rough Stone", "rough_stone"],
    ["Facade - Ground Level", "facade.ground_level"],
    ["Facade - Ground Level - Door", "facade.ground_level.door"],
    ["Facade - Upper Level", "facade.upper_level"],
    ["Facade - Upper Level - Chimney", "facade.upper_level.chimney"],
    ["Necromancer's Ossuary", "necromancer"],  
];
texture_file = texture_files[keyLookup(texture_files, [TEXTURE])][1];

size_data = [
    ["2x (A)", 2, "A"],
    ["1x (IA)", 1, "IA"],
    ["1.5x (BA)", 1.5, "BA"],
    ["3x (D)", 3, "D"],
    ["4x (Q)", 4, "Q"]
];
x = size_data[keyLookup(size_data, [SIZE])][1];
size_file = size_data[keyLookup(size_data, [SIZE])][2];



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
    color("Grey") base_wall_primary(x,square_basis_number);
}
