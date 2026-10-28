// Module test: the snap magnet cut-out alone. The runner checks its volume and
// bbox against golden.json; assert() covers the invariants that must always hold.
include <../../lock_snap_magnetic.scad>

magnet_hole = 6;
magnet_height = 2.6;

// The disk must be able to flip inside a magnet_hole-sized chamber: √(d²+h²) ≤ hole for a 5x3 magnet.
assert(sqrt(5^2 + 3^2) <= magnet_hole + 0.2, "5x3 disk can't flip in this magnet_hole");

snap_magnetic_negative(magnet_hole, magnet_height);
