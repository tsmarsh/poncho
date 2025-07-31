include <grid.scad>
include <hex.scad>

hexagon_side = 20;  // Length of a side of the hexagon
gap = 1;  // Gap between hexagons
rows = 4;  // Number of rows
cols = 4;  // Number of columns
h = 15;
g = grid(hexagon_side, gap, rows, cols);
scale = 1.2;

            
function i_list (list, i) = [for (coord = list) coord[i]];
    
    
echo( second_max([1,2,3,4,5,5,6]));

function min_i(list, i) = min(i_list(list, i));
function max_i(list, i) = max(i_list(list, i));


X = 0;
Y = 1;
Z = 2;


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


module net(side, scale, height, up = true, left = true, right = true) {
    s = (2*side/3) * scale;
    h = height * scale;
    
    union() {
        hexagon((2*s/3), h, 1);
        
        if(up)    leg(side * scale, h, 0);
        if(left)  leg(side * scale, h, 120);
        if(right) leg(side * scale, h, 240);
    }
}

module cell(side, height, up = true, left = true, right = true) {
    difference() {
        hexagon(side * 0.7 , height);
        translate([0,0,height/4])
            net(side, 1.2, height/2, up, left, right);
    }
    translate([0,0,height*1.2/4])
        net(side, 1, height/2, up, left, right);
}

module comb(rows, columns, side, height) {
    for(r = [0 : rows]) {
        echo("r: ", r);
        for(c = [0 : cols]) {
            echo("c: ", c);
            translate([c*side* 1.5, (r * sqrt(3) * side) + (c%2 * side), 0])
                cell(side, height, c < cols, r > 0 && c > 0, r < rows && c > 0);
        }
    }
}

//comb(0,0,10,10);

module web(side, scale, height, g) {
    min_x = min_i(g, X);
    max_x = max_i(g, X);
    
    min_y = min_i(g, Y);
    max_y = max_i(g, Y);
    
    
    for(t = g) {
       {
            
            translate(t) 
                net(side,scale, height, t[Y] < max_y, t[X] > min_x && t[Y] > min_y, t[X] < max_x && t[Y] > min_y);
        }
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

