function hex_points(rad) = [for(i = [0:60:300]) [rad * cos(i), rad * sin(i)]];


module smooth_hex(R, r) {
    rad = R - r/2;
    hull() {
        translate([0,0,r/2])
        for (p = hex_points(rad)) {
            translate(p)
                sphere(r/2, $fn = 50);
        }
    }
}

module hexagon(side, height, scale = 1.2) {
    linear_extrude(height = height, scale = scale)
    polygon(hex_points(side));
}

test = false;

if(test) {
    hexagon(10,5, 1);
    
    translate([0, 30, 0])
        smooth_hex(10, 5);
}

