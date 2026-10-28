include <impl_square.scad>

/*
 * Connector Positive
 */
module connector_positive_curved(x,y,square_basis,edge_width) {
    if(x == 6 && y == 6) {
        connector_positive_curved_large_6(square_basis,edge_width);
    } else if (x == 8 && y == 8) {
        connector_positive_curved_large_8(square_basis,edge_width);
    } else if (x > 4 || y > 4) {
        echo("Curved does not support ", x, "x", y);
    } else {
        connector_positive_square_notch(x,y,square_basis,edge_width,east=false,north=false);
    }
}

module connector_positive_curved_large_6(square_basis, edge_width) {
    if (CURVED_LARGE == "complete") {
        connector_positive_square_notch(x,y,square_basis,edge_width,east=false,north=false);
    } else if(CURVED_LARGE == "a") {
        connector_positive_large_6_a(square_basis,edge_width);
    } else if(CURVED_LARGE == "b") {
        translate([square_basis*6/2, square_basis*6/2,0]) connector_positive_square_notch(6/2-1,6/2-1,square_basis,edge_width,east=false,north=false);
    } else if(CURVED_LARGE == "c") {
        rotate([0,0,-90]) mirror([1,0,0]) {
            connector_positive_large_6_a(square_basis,edge_width);
        }
    } else if(CURVED_LARGE == "ac") {
        connector_positive_large_6_ac(square_basis,edge_width);
    } else {
        echo("Curved 6x6 only supports a, b, c & ac");
    }
}

module connector_positive_curved_large_8(square_basis, edge_width) {
    if(CURVED_LARGE == "a") {
        connector_positive_large_8_a(square_basis,edge_width);
    } else if(CURVED_LARGE == "b") {
        translate([square_basis*8/2, square_basis*8/2,0]) connector_positive_square_notch(8/2-1,8/2-1,square_basis,edge_width,east=false,north=false);
    } else if(CURVED_LARGE == "c") {
        rotate([0,0,-90]) mirror([1,0,0]) {
            connector_positive_large_8_a(square_basis,edge_width);
        }
    } else if(CURVED_LARGE == "ac") {
        connector_positive_large_8_ac(square_basis,edge_width);
    } else if(CURVED_LARGE == "ax") {
        connector_positive_large_8_ax(square_basis,edge_width);
    } else if(CURVED_LARGE == "cx") {
        mirror([1,0,0]) connector_positive_large_8_ax(square_basis,edge_width);
    } else {
        echo("Curved 8x8 only supports a, b, c, ac, ax & cx");
    }
}

module connector_positive_large_6_a(square_basis,edge_width) {
    translate([0,square_basis*5,0]) connector_positive_square_notch(2,1,square_basis,edge_width,east=false,north=false);
    translate([square_basis*2,square_basis*3,0]) connector_positive_square_notch(1,2,square_basis,edge_width,north=false);
}

module connector_positive_large_6_ac(square_basis,edge_width) {
    translate([square_basis*-2,square_basis*5,0]) connector_positive_square_notch(4,1,square_basis,edge_width,east=false,north=false);
    translate([square_basis*2,square_basis*3,0]) connector_positive_square_notch(1,2,square_basis,edge_width,north=false);
    mirror([1,0,0]) translate([square_basis*2,square_basis*3,0]) connector_positive_square_notch(1,2,square_basis,edge_width,north=false);
}

module connector_positive_large_8_a(square_basis,edge_width) {
    translate([0,square_basis*6,0]) connector_positive_square_notch(4,2,square_basis,edge_width,east=false,north=false);
    translate([0,square_basis*6,0]) translate([square_basis*4,square_basis*(1)-square_basis/2,0]) rotate([0,0,180]) center_connector_positive(y,x, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE);
}

module connector_positive_large_8_ac(square_basis,edge_width) {
    translate([square_basis*-2,square_basis*6,0]) connector_positive_square_notch(4,2,square_basis,edge_width,north=false);
}

module connector_positive_large_8_ax(square_basis,edge_width) {
    translate([square_basis*2,square_basis*6,0]) connector_positive_square_notch(2,2,square_basis,edge_width,east=false,north=false);
}

/*
 * Connector Negative
 */
module connector_negative_curved(x,y,square_basis,edge_width,od_connectors=0,curved_magnets=true) {
    if(x == 6 && y == 6) {
        connector_negative_curved_large_6(square_basis,edge_width,od_connectors,curved_magnets);
    } else if (x == 8 && y == 8) {
        connector_negative_curved_large_8(square_basis,edge_width);
    } else if (x > 6 || y > 6) {
        echo("Curved does not support ", x, "x", y);
    } else {
        connector_negative_curved_large_impl(x,y,square_basis,edge_width,od_connectors,curved_magnets);
    }
}

module connector_negative_curved_large_impl(x,y,square_basis,edge_width,od_connectors=0,curved_magnets=true) {
    connector_negative_square_notch(x,y,square_basis,edge_width,east=false,north=false);
    if (od_connectors > 0) {
        angle = 90;
        for ( i = [1 : od_connectors] ) {
            rotate([0,0,90-angle/(od_connectors+1)*i]) translate([square_basis*x,0,0]) rotate([0,0,180]) connector_negative(square_basis, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, right=false, left=false);
        }
        if (curved_magnets) {
            for ( i = [1 : od_connectors + 1] ) {
                rotate([0,0,90-angle/(od_connectors+1)*i+angle/(od_connectors+1)/2]) translate([square_basis*x,0,0]) rotate([0,0,180]) center_connector_negative(edge_width, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, height=HEIGHT, topless=TOPLESS);
            }
        }
    }
}

module connector_negative_curved_large_6(square_basis, edge_width, od_connectors, curved_magnets) {
    if (CURVED_LARGE == "complete") {
        connector_negative_curved_large_impl(x,y,square_basis,edge_width,od_connectors,curved_magnets);
    } else if(CURVED_LARGE == "a") {
        connector_negative_large_6_a(square_basis,edge_width);
    } else if(CURVED_LARGE == "b") {
        translate([square_basis*6/2, square_basis*6/2,0]) connector_negative_square_notch(6/2-1,6/2-1,square_basis,edge_width,east=false,north=false);
    } else if(CURVED_LARGE == "c") {
        rotate([0,0,-90]) mirror([1,0,0]) {
            connector_negative_large_6_a(square_basis,edge_width);
        }
    } else if(CURVED_LARGE == "ac") {
        connector_negative_large_6_ac(square_basis,edge_width);
    } else {
        echo("Curved 6x6 only supports a, b, c & ac");
    }
}

module connector_negative_curved_large_8(square_basis, edge_width) {
    if(CURVED_LARGE == "a") {
        connector_negative_large_8_a(square_basis,edge_width);
    } else if(CURVED_LARGE == "b") {
        if (MAGNETS == "none" && (LOCK == "openlock" || LOCK == "triplex")) {
            translate([square_basis*8/2, square_basis*8/2,0]) union() {
                connector_negative_square_notch(8/2-2,8/2-2,square_basis,edge_width,east=false,north=false);
                translate([0,square_basis*2,0]) connector_negative(square_basis, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, right=false, left=false);
                translate([square_basis*2,0,0]) rotate([0,0,90]) connector_negative(square_basis, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, right=false, left=false);
            }
        } else {
            translate([square_basis*8/2, square_basis*8/2,0]) connector_negative_square_notch(8/2-1,8/2-1,square_basis,edge_width,east=false,north=false);
        }
    } else if(CURVED_LARGE == "c") {
        rotate([0,0,-90]) mirror([1,0,0]) {
            connector_negative_large_8_a(square_basis,edge_width);
        }
    } else if(CURVED_LARGE == "ac") {
        connector_negative_large_8_ac(square_basis,edge_width);
    } else if(CURVED_LARGE == "ax") {
        connector_negative_large_8_ax(square_basis,edge_width);
    } else if(CURVED_LARGE == "cx") {
        mirror([1,0,0]) connector_negative_large_8_ax(square_basis,edge_width);
    } else {
        echo("Curved 8x8 only supports a, b, c, ac, ax & cx");
    }
}

module connector_negative_large_6_a(square_basis,edge_width) {
    translate([0,square_basis*5,0]) connector_negative_square_notch(2,1,square_basis,edge_width,east=false,north=false);
    translate([square_basis*2,square_basis*3,0]) connector_negative_square_notch(1,2,square_basis,edge_width,north=false);
}

module connector_negative_large_6_ac(square_basis,edge_width) {
    translate([square_basis*-2,square_basis*5,0]) connector_negative_square_notch(4,1,square_basis,edge_width,east=false,north=false, west=false);
    translate([square_basis*2,square_basis*3,0]) connector_negative_square_notch(1,2,square_basis,edge_width,north=false);
    mirror([1,0,0]) translate([square_basis*2,square_basis*3,0]) connector_negative_square_notch(1,2,square_basis,edge_width,north=false);
}

module connector_negative_large_8_a(square_basis,edge_width) {
    translate([0,square_basis*6,0]) connector_negative_square_notch(4,2,square_basis,edge_width,east=false,north=false);
    translate([0,square_basis*6,0]) translate([square_basis*4,square_basis*(1)-square_basis/2,0]) rotate([0,0,180]) center_connector_negative(y,x, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE);
}

module connector_negative_large_8_ac(square_basis,edge_width) {
    translate([square_basis*-2,square_basis*6,0]) connector_negative_square_notch(4,2,square_basis,edge_width,north=false);
}

module connector_negative_large_8_ax(square_basis,edge_width) {
    translate([square_basis*2,square_basis*6,0]) connector_negative_square_notch(2,2,square_basis,edge_width,east=false,north=false);
}

/*
 * Plain base exterior
 */
module plain_base_curved(x,y,square_basis,edge_width) {
    if(x == 6 && y == 6) {
        plain_curved_large_6(square_basis,edge_width);
    } else if (x == 8 && y == 8) {
        plain_curved_large_8(square_basis,edge_width);
    } else if (x > 4 || y > 4) {
        echo("Curved does not support ", x, "x", y);
    } else {
        plain_curved(x,y,square_basis,edge_width);
    }
}

module plain_curved(x,y,square_basis,edge_width) {
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
}


module plain_curved_large_6(square_basis, edge_width) {
    if (CURVED_LARGE == "complete") {
        plain_curved(x,y,square_basis,edge_width);
    } else if(CURVED_LARGE == "a") {
        plain_curved_large_6_a(square_basis,edge_width);
    } else if(CURVED_LARGE == "b") {
        plain_curved_large_b(x,y,square_basis,edge_width);
    } else if(CURVED_LARGE == "c") {
        rotate([0,0,-90]) mirror([1,0,0]) {
            plain_curved_large_6_a(square_basis,edge_width);
        }
    } else if(CURVED_LARGE == "ac") {
        union() {
            plain_curved_large_6_a(square_basis,edge_width);
            mirror([1,0,0]) {
                plain_curved_large_6_a(square_basis,edge_width);
            }
        }
    } else {
        echo("Curved 6x6 only supports a, b, c & ac");
    }
}

module plain_curved_large_8(square_basis, edge_width) {
    if(CURVED_LARGE == "a") {
        plain_curved_large_8_a(square_basis,edge_width);
    } else if(CURVED_LARGE == "b") {
        plain_curved_large_b(x,y,square_basis,edge_width);
    } else if(CURVED_LARGE == "c") {
        rotate([0,0,-90]) mirror([1,0,0]) {
            plain_curved_large_8_a(square_basis,edge_width);
        }
    } else if(CURVED_LARGE == "ac") {
        plain_curved_large_8_ac(square_basis,edge_width);
    } else if(CURVED_LARGE == "ax") {
        plain_curved_large_8_ax(square_basis,edge_width);
    } else if(CURVED_LARGE == "cx") {
        mirror([1,0,0]) plain_curved_large_8_ax(square_basis,edge_width);
    } else {
        echo("Curved 8x8 only supports a, b, c, ac, ax & cx");
    }
}

module plain_curved_large_6_a(square_basis,edge_width) {
    x = 6;
    y = 6;
    innerx = 3;
    innery = 3;

    difference() {
        union() {
            difference() {
                intersection() {
                    translate([0,innery*square_basis,0]) plain_square_positive(innerx,innery,square_basis);
                    hull() {
                        translate([0,0,0.4]) scale([x,y,1]) cylinder(5.6,square_basis,square_basis,$fn=200);
                        translate([0,0,0]) scale([x-(.25/square_basis),y-(.25/square_basis),1]) cylinder(0.4,square_basis,square_basis,$fn=200);
                    }
                }
                intersection() {
                    translate([0,innery*square_basis,0]) plain_square_negative(innerx,innery,square_basis,edge_width);
                    translate([0,0,-1]) scale([((x*square_basis)-edge_width)/square_basis,((y*square_basis)-edge_width)/square_basis,1]) cylinder(8,square_basis,square_basis,$fn=200);
                }
            }
            intersection() {
                hull() {
                    translate([0,innery*square_basis,0.4]) cube([square_basis*(innerx-1)+edge_width+1, square_basis*(innery-1)+edge_width+1, 5.6]);
                    translate([0.25,innery*square_basis+.25,0]) cube([square_basis*(innerx-1)+edge_width+1-.5, square_basis*(innery-1)+edge_width+1-.5, .4]);
                }
                cylinder(6,square_basis*x-1,square_basis*y-1,$fn=200);
            }
        }
        union() {
            translate([-1,innery*square_basis-1,-1]) cube([square_basis*(innerx-1)+1, square_basis*(innery-1)+1, 8]);
            hull() {
                translate([-1,innery*square_basis-1,0]) cube([square_basis*(innerx-1)+1, square_basis*(innery-1)+1, .4]);
                translate([-1,innery*square_basis-1,-0.01]) cube([square_basis*(innerx-1)+1.25, square_basis*(innery-1)+1.25, 0.01]);
            }
        }
    }
}

module plain_curved_large_8_a(square_basis,edge_width) {
    x = 8;
    y = 8;
    
    difference() {
        intersection() {
            hull() {
                translate([0,6*square_basis,0]) plain_square_positive(4,2,square_basis);
            }
            hull() {
                translate([0,0,.4]) scale([x,y,1]) cylinder(5.6,square_basis,square_basis,$fn=200);
                translate([0,0,0]) scale([x-(.25/square_basis),y-(.25/square_basis),1]) cylinder(.4,square_basis,square_basis,$fn=200);
            }
        }
        intersection() {
            translate([0,6*square_basis,0]) plain_square_negative(4,2,square_basis,edge_width);
            translate([0,0,-1]) scale([((x*square_basis)-edge_width)/square_basis,((y*square_basis)-edge_width)/square_basis,1]) cylinder(8,square_basis,square_basis,$fn=200);
        }
    }
}

module plain_curved_large_b(x,y,square_basis,edge_width) {
    innerx = x/2;
    innery = y/2;

    difference() {
        intersection() {
            translate([innerx*square_basis,innery*square_basis,0]) plain_square_positive(innerx,innery,square_basis);
            hull() {
                translate([0,0,.4]) scale([x,y,1]) cylinder(5.6,square_basis,square_basis,$fn=200);
                translate([0,0,0]) scale([x-(.25/square_basis),y-(.25/square_basis),1]) cylinder(.4,square_basis,square_basis,$fn=200);
            }
        }
        intersection() {
            translate([innerx*square_basis,innery*square_basis,0]) plain_square_negative(innerx,innery,square_basis,edge_width);
            translate([0,0,-1]) scale([((x*square_basis)-edge_width)/square_basis,((y*square_basis)-edge_width)/square_basis,1]) cylinder(8,square_basis,square_basis,$fn=200);
        }
    }
}

module plain_curved_large_8_ac(square_basis,edge_width) {
    x = 8;
    y = 8;
    
    difference() {
        intersection() {
            hull() {
                translate([square_basis*-2,6*square_basis,0]) plain_square_positive(4,2,square_basis);
            }
            hull() {
                translate([0,0,.4]) scale([x,y,1]) cylinder(5.6,square_basis,square_basis,$fn=200);
                translate([0,0,0]) scale([x-(.25/square_basis),y-(.25/square_basis),1]) cylinder(.4,square_basis,square_basis,$fn=200);
            }
        }
        intersection() {
            translate([square_basis*-2,6*square_basis,0]) plain_square_negative(4,2,square_basis,edge_width);
            translate([0,0,-1]) scale([((x*square_basis)-edge_width)/square_basis,((y*square_basis)-edge_width)/square_basis,1]) cylinder(8,square_basis,square_basis,$fn=200);
        }
    }
}

module plain_curved_large_8_ax(square_basis,edge_width) {
    x = 8;
    y = 8;
    
    difference() {
        intersection() {
            hull() {
                translate([square_basis*2,6*square_basis,0]) plain_square_positive(2,2,square_basis);
            }
            hull() {
                translate([0,0,.4]) scale([x,y,1]) cylinder(5.6,square_basis,square_basis,$fn=200);
                translate([0,0,0]) scale([x-(.25/square_basis),y-(.25/square_basis),1]) cylinder(.4,square_basis,square_basis,$fn=200);
            }
        }
        intersection() {
            translate([square_basis*2,6*square_basis,0]) plain_square_negative(2,2,square_basis,edge_width);
            translate([0,0,-1]) scale([((x*square_basis)-edge_width)/square_basis,((y*square_basis)-edge_width)/square_basis,1]) cylinder(8,square_basis,square_basis,$fn=200);
        }
    }
}

