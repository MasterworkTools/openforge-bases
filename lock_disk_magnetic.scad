/*
 * Disk Magnet
 */

// Magnet Hole
// To determine the correct magnet hole needed for a cylindrical magnet to
// freely spin apply the Pythagorean theorem √(d²+h²) to the dimensions. For a
// standard 5x3 magnet that comes out to about 5.83. The magnet hole could never
// be smaller than 5.83 if you want to support polarity changes. Don't forget to
// account for printer tolerances too. Though this would be trivial to calculate
// for the user, we leave it to them to freely input as we shouldn't assume
// their specific situation or use case; such as uncommon base hights, magnets,
// printer settings, tolerances, etc. That being said, the disk magnet lock has
// been optimized for the most common use case; a standard 6mm base with a 5x3
// magnet. For these variables a 6mm magnet hole is perfect.

// Magnet Height
// To determine the correct magnet hight, use a pair of calipers to measure the
// actual magnet's height. It is critical for the insert slot to be equal to the
// magnet height or the magnet could fall out or be impossible to snap in. I
// have found that most 5x3 magnets are actually 5x2.6, that slight inaccuracy
// cloud lead to issues. The insert slot has a pilot hole (square really) that
// is .5mm larger than the magnet height to help align the magnet before
// snapping them in. Once they are in, they should be nearly impossible to
// remove without cutting them out.
module disk_magnetic_positive(magnet_hole=6, magnet_height=2.6) {
    if (magnet_hole > 0) {
        translate([0,-(magnet_hole+2)/2,0]) cube([magnet_hole+2,magnet_hole+2,magnet_hole]);
    }
}

module disk_magnetic_negative(magnet_hole=6, magnet_height=3) {
    if (magnet_hole > 0) {
        $fn=100;

        // Padding to to break through bottom faces, stupid open scad face bleeding.
        bottom_pad = 1;

        // Offset the whole model by 1 for base wall
        translate([1,0,0]) {
            // A sphere allows the magnet to freely spin while keeping it from
            // traveling too far back towards the center of the base, where it
            // could end up closer to and connected to it's own base magnets
            // rather than the magnets in the adjacent base.
            translate([magnet_hole/2,0,magnet_hole/2]) sphere(d = magnet_hole);

            // The cylinder provides a flat surface against the outside wall.
            // This also gives the magnet more travel room on the side you want
            // it to lock to.
            translate([0,0,magnet_hole/2]) rotate([0,90,0]) cylinder(h = magnet_hole/2, d = magnet_hole);


            // The insert hole should be exactly the same height as the magnet
            // so it can not fall out once it is snapped in.
            translate([0,-magnet_height/2,-bottom_pad]) cube([magnet_hole,magnet_height,(magnet_hole/2)+bottom_pad]);

            // The pilot hole makes the center of the insert whole slightly
            // larger to help guild the magnet into the chamber.
            pilot_hole_pad = .5;
            translate([(magnet_hole/2)-(magnet_height/2)-(pilot_hole_pad/2),-(magnet_height/2)-(pilot_hole_pad/2),-bottom_pad]) cube([magnet_height+pilot_hole_pad,magnet_height+pilot_hole_pad,(magnet_hole/2)+bottom_pad]);
        }
    }
}
