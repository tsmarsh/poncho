include <grid.scad>
include <hex.scad>

hexagon_side = 20;  // Length of a side of the hexagon
gap = 2;  // Gap between hexagons
rows = 5;  // Number of rows
cols = 3;  // Number of columns
h = 15;
g = grid(hexagon_side, gap, rows, cols);
scale = 1.2;

module blobs(side, height, g) {
    for(t = g) {
        translate(t)
            smooth_hex(side,height);
    }   
}

module shields(side, height, g) {
    for(t = g) {
        translate(t)
              hexagon(side * 0.8, height, 1.2);
    }   
}

module leg(side, h, i) {
    width = side / 3;
    
    rotate([0,0,i])
        linear_extrude(h)
            translate([-width / 2, 0,0])
                square([width, sqrt(3) * side]);
}


module net(side, scale, height) {
    s = (2*side/3) * scale;
    h = height * scale;
    
    union() {
        hexagon(s, h, 1);
        
        leg(side * scale, h, 0);
        leg(side * scale, h, 120);
        leg(side * scale, h, 240);
    }
}


module web(side, scale, height, g) {
    for(t = g) {
        translate(t) 
            net(side,scale, height);
    }
}

module club(side, h, i) {
    width = side / 3;
    
    rotate([0,0,i])
        linear_extrude(h)
            union() {
                polygon(head_points(side));
                translate([-width / 2, side / sqrt(2),0])
                    square([width, sqrt(3) * side]);
            }
}



function head_points(rad) = [
    [0, 0],
    [rad * cos(0), rad * sin(0)],
    [rad * cos(60), rad * sin(60)],
    [rad * cos(120), rad * sin(120)]
];


club(10, 6, 0);
color("blue")
club(10, 6, 120);
color("yellow")
club(10, 6, 2);

