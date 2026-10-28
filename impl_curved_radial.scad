include <impl_square.scad>

/*
 * Connector Positive
 */
module connector_positive_curved_radial(x,y,square_basis,edge_width) {
    connector_positive_square_notch(x,y,square_basis,edge_width,east=false,north=false);
}

/*
 * Connector Negative
 */
module connector_negative_curved_radial(x, cut, angle, square_basis, edge_width, id_connectors, od_connectors, id_magnets, od_magnets) {
    translate([0,cut*square_basis,0]) connector_negative_square_notch(x-cut,x-cut,square_basis,edge_width,east=false,north=false,south=false);
    rotate([0,0,90-angle]) translate([cut*square_basis,0,0]) connector_negative_square_notch(x-cut,x-cut,square_basis,edge_width,west=false,east=false,north=false);
    if (id_connectors > 0) {
        for ( i = [1 : id_connectors] ) {
            rotate([0,0,90-angle/(id_connectors+1)*i]) translate([square_basis*cut,0,0])  connector_negative(square_basis, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, right=false, left=false);
        }
        if (id_magnets) {
            for ( i = [1 : id_connectors + 1] ) {
                rotate([0,0,90-angle/(od_connectors+1)*i+angle/(od_connectors+1)/2]) translate([square_basis*cut,0,0]) rotate([0,0,0]) center_connector_negative(edge_width, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, height=HEIGHT, topless=TOPLESS);
            }
        }
    }
    if (od_connectors > 0) {
        for ( i = [1 : od_connectors] ) {
            rotate([0,0,90-angle/(od_connectors+1)*i]) translate([square_basis*x,0,0]) rotate([0,0,180]) connector_negative(square_basis, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, right=false, left=false);
        }
        if (od_magnets) {
            for ( i = [1 : od_connectors + 1] ) {
                rotate([0,0,90-angle/(od_connectors+1)*i+angle/(od_connectors+1)/2]) translate([square_basis*x,0,0]) rotate([0,0,180]) center_connector_negative(edge_width, PRIORITY, LOCK, MAGNETS, MAGNET_HOLE, MAGNET_HEIGHT, height=HEIGHT, topless=TOPLESS);
            }
        }
    }
}

/*
 * Plain base exterior
 */
module plain_base_curved_radial(x, cut, angle, square_basis, edge_width) {
    difference() {
        intersection() {
            hull() {
                translate([0,0,0.4]) scale([x,x,1]) cylinder(HEIGHT-.4,square_basis,square_basis,$fn=200);
                translate([0,0,0]) scale([(x-.25/square_basis),(x-0.25/square_basis),1]) cylinder(.4,square_basis,square_basis,$fn=200);
            }
        }
        translate([0,0,0]) scale([cut,cut,1]) cylinder(HEIGHT+.1,square_basis,square_basis,$fn=200);
        rotate([0,0,90]) translate([-x*square_basis-1,0,-1]) cube([x*square_basis*2+2, x*square_basis+1, HEIGHT+2]);
        rotate([0,0,-angle]) translate([0,-x*square_basis-1,-1]) cube([x*square_basis+1, x*square_basis*2+2, HEIGHT+2]);

        hull() {
            scale([cut,cut,1]) cylinder(0.4,square_basis,square_basis,$fn=200);
            translate([0,0,-1]) scale([cut,cut,1]) cylinder(1,square_basis+0.25,square_basis+0.25,$fn=200);
        };
        difference() {
            translate([0,0,-1]) scale([((x*square_basis)-edge_width)/square_basis,((x*square_basis)-edge_width)/square_basis,1]) cylinder(HEIGHT+2,square_basis,square_basis,$fn=200);
            translate([0,0,-1]) scale([((cut*square_basis)+edge_width)/square_basis,((cut*square_basis)+edge_width)/square_basis,1]) cylinder(HEIGHT+2,square_basis,square_basis,$fn=200);
            rotate([0,0,90]) translate([-x*square_basis-1,-edge_width,-1]) cube([x*square_basis*2+2, x*square_basis+1, HEIGHT+2]);
            rotate([0,0,-angle]) translate([-edge_width,-x*square_basis-1,-1]) cube([x*square_basis+1, x*square_basis*2+2, HEIGHT+2]);
        }
    }
}

