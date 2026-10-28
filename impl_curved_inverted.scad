include <impl_square.scad>

/*
 * Plain base exterior
 */

/*
x = 7;
cut = 6;
square_basis=25.4;
edge_width=12.7;
NOTCH="false";
HEIGHT=6;
CENTER = "true";
LOCK = "infinitylock";
TOPLESS = "true";
MAGNETS = "none";
MAGNET_HOLE = 5;
PRIORITY = "lock";
CURVED_LARGE = "b";

difference() {
    color("green")plain_base_curved_inverted_7a(x,cut,square_basis,edge_width);
    connector_negative_curved_inverted_7a(x, cut, square_basis, edge_width, 7);
}

difference() {
    plain_base_curved_inverted(x, cut, square_basis, edge_width);
    connector_negative_curved_inverted(x, cut, square_basis, edge_width, 7);
}

difference() {
    rotate([0,0,90]) mirror([0,1,0]) color("green")plain_base_curved_inverted_7a(x,cut,square_basis,edge_width);
    rotate([0,0,90]) mirror([0,1,0]) connector_negative_curved_inverted_7a(x, cut, square_basis, edge_width, 7);
}
*/

module plain_base_curved_inverted(x,cut,square_basis,edge_width) {
    if(x == 7) {
        if (CURVED_LARGE == "a") {
            plain_base_curved_inverted_7a(x,cut,square_basis,edge_width);
        } else if (CURVED_LARGE == "b") {
            plain_base_curved_inverted_7b(x,cut,square_basis,edge_width);
        } else if (CURVED_LARGE == "c") {
            rotate([0,0,90]) mirror([0,1,0]) plain_base_curved_inverted_7a(x,cut,square_basis,edge_width);
        }
    } else {
        plain_base_curved_inverted_default(x,cut,square_basis,edge_width);
    }    
}

module plain_base_curved_inverted_default(x,cut,square_basis,edge_width) {
    difference() {
        plain_square_positive(x,x,square_basis);
        translate([0,0,0]) scale([cut,cut,1]) cylinder(HEIGHT+.1,square_basis,square_basis,$fn=200);
        hull() {
            scale([cut,cut,1]) cylinder(0.4,square_basis,square_basis,$fn=200);
            translate([0,0,-1]) scale([cut,cut,1]) cylinder(1,square_basis+0.25,square_basis+0.25,$fn=200);
        };

        difference() {
            plain_square_negative(x,x,square_basis,edge_width);
            translate([0,0,-1]) scale([((cut*square_basis)+edge_width)/square_basis,((cut*square_basis)+edge_width)/square_basis,1]) cylinder(HEIGHT+2,square_basis,square_basis,$fn=200);
        }
    }
}

module plain_base_curved_inverted_7a(x,cut,square_basis,edge_width) {
    new_x = 5;
    new_y = x - cut + 1;
    difference() {
        translate([0,(cut-1)*square_basis]) plain_square_positive(new_x,new_y,square_basis);
        translate([0,0,0]) scale([cut,cut,1]) cylinder(HEIGHT+.1,square_basis,square_basis,$fn=200);
        hull() {
            scale([cut,cut,1]) cylinder(0.4,square_basis,square_basis,$fn=200);
            translate([0,0,-1]) scale([cut,cut,1]) cylinder(1,square_basis+0.25,square_basis+0.25,$fn=200);
        };

        difference() {
            translate([0,(cut-1)*square_basis]) plain_square_negative(new_x,new_y,square_basis,edge_width);
            translate([0,0,-1]) scale([((cut*square_basis)+edge_width)/square_basis,((cut*square_basis)+edge_width)/square_basis,1]) cylinder(HEIGHT+2,square_basis,square_basis,$fn=200);
        }
    }
}

module plain_base_curved_inverted_7b(x,cut,square_basis,edge_width) {
    tmp_edge_width = 6.55;
    new_x = 2;
    new_y = 2;
    difference() {
        translate([3*square_basis,3*square_basis]) plain_square_positive(new_x,new_y,square_basis);
        translate([0,0,0]) scale([cut,cut,1]) cylinder(HEIGHT+.1,square_basis,square_basis,$fn=200);
        hull() {
            scale([cut,cut,1]) cylinder(0.4,square_basis,square_basis,$fn=200);
            translate([0,0,-1]) scale([cut,cut,1]) cylinder(1,square_basis+0.25,square_basis+0.25,$fn=200);
        };

        difference() {
            translate([3*square_basis,3*square_basis]) plain_square_negative(new_x,new_y,square_basis,tmp_edge_width);
            translate([0,0,-1]) scale([((cut*square_basis)+tmp_edge_width)/square_basis,((cut*square_basis)+tmp_edge_width)/square_basis,1]) cylinder(HEIGHT+2,square_basis,square_basis,$fn=200);
        }
    }
}

/*
 * Connectors
 */

module connector_negative_curved_inverted(x, cut, square_basis, edge_width, id_connectors) {
    if(x == 7) {
        if (CURVED_LARGE == "a") {
            connector_negative_curved_inverted_7a(x,cut,square_basis,edge_width,id_connectors);
        } else if (CURVED_LARGE == "b") {
            connector_negative_curved_inverted_7b(x,cut,square_basis,edge_width,id_connectors);
        } else if (CURVED_LARGE == "c") {
            rotate([0,0,90]) mirror([0,1,0]) connector_negative_curved_inverted_7a(x,cut,square_basis,edge_width,id_connectors);
        }
    } else {
        connector_negative_curved_inverted_default(x,cut,square_basis,edge_width,id_connectors);
    }    
}

module connector_negative_curved_inverted_default(x, cut, square_basis, edge_width, id_connectors) {
    connector_negative_square_notch(x,x,square_basis,edge_width,west=false,south=false);
    translate([0,cut*square_basis,0]) connector_negative_square_notch(x-cut,x-cut,square_basis,edge_width,east=false,north=false,south=false);
    translate([cut*square_basis,0,0]) connector_negative_square_notch(x-cut,x-cut,square_basis,edge_width,west=false,east=false,north=false);

    if (id_connectors > 0) {
        for ( i = [1 : id_connectors] ) {
            rotate([0,0,90/(id_connectors+1)*i]) translate([square_basis*cut,0,0])  connector_negative(square_basis, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, right=false, left=false);
        }
    }
}

module connector_negative_curved_inverted_7a(x, cut, square_basis, edge_width, id_connectors) {
    new_x = 5;
    new_y = x - cut + 1;

    translate([0,(cut-1)*square_basis]) connector_negative_square_notch(new_x,new_y,square_basis,edge_width,west=false,south=false);
    translate([0,cut*square_basis,0]) connector_negative_square_notch(x-cut,x-cut,square_basis,edge_width,east=false,north=false,south=false);
    translate([4*square_basis,5*square_basis,0]) connector_negative_square_notch(1,1,square_basis,edge_width,west=false,east=false,north=false);

    difference() {
        if (id_connectors > 0) {
            union() {
                for ( i = [1 : id_connectors] ) {
                    rotate([0,0,90/(id_connectors+1)*i]) translate([square_basis*cut,0,0])  connector_negative(square_basis, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, right=false, left=false);
                }
            }
        }
        rotate([0,0,-30]) translate([0,0,-1]) cube([300,300,HEIGHT+2]);
    }
}

module connector_negative_curved_inverted_7b(x, cut, square_basis, edge_width, id_connectors) {
    new_x = 5;
    new_y = x - cut + 1;

    translate([4*square_basis,4*square_basis,0]) connector_negative_square_notch(1,1,square_basis,edge_width,west=false,south=false);

    rotate([0,0,45]) translate([square_basis*cut,0,0])  connector_negative(square_basis, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, right=false, left=false);
}
