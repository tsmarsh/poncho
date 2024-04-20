// Parameters
hexagon_side = 20;  // Length of a side of the hexagon
gap = 1;  // Gap between hexagons
rows = 5;  // Number of rows
cols = 3;  // Number of columns
h = 15;
g = grid(hexagon_side, gap, rows, cols);
scale = 1.2;


module smooth_hex(R, r) {
    rad = R - r/2;
    hull() {
        for (p = [for(i = [0:60:300]) [rad * cos(i), rad * sin(i)]]) {
            translate(p)
                sphere(r/2, $fn = 50);
        }
    }
}

module hexagon(side, height) {
    linear_extrude(height = height, scale = 1.2)
    polygon([for(i = [0:60:300]) [side * 0.8 * cos(i), side * 0.8 * sin(i)]]);
}

module leg(side, h, i) {
    rotate([0,0,i])
            linear_extrude(h)
            translate([-side / 4, 0,0])
            square([side / 3, sqrt(3) * side]);
}


module net(side, scale, height) {
    s = (2*side/3) * scale;
    h = height * scale;
    
    union() {
        hexagon(s, h);
        
        leg(side * scale, h, 0);
        leg(side * scale, h, 120);
        leg(side * scale, h, 240);
    }
}

    
function alpha(r, c, grid_height, side_length) = let(
    y = r * grid_height, 
    x = c * side_length * 3) [x, y, 0];
 
 
function beta(r, c, grid_height, grid_width, side_length) = let(
    y = r * grid_height + (grid_height /2 ),
    x = c * side_length * 3 + grid_width) [x, y, 0];

    
function grid(side, gap, rows, cols) = let(
    side_length = side + gap,
    
    grid_height = sqrt(3) * side_length,
    grid_width = 1.5 * side_length,
    grid_a = [for (r = [0:1:(rows-1)/2]) 
                  for (c = [0:1:cols/2]) 
                    alpha(r, c, grid_height, side_length)],
    
    grid_b = [ 
        for (r = [0:1:(rows-1)/2]) 
            for (c = [0:1:cols/2]) 
                beta(r, c, grid_height, grid_width, side_length)]) 
    
    concat(grid_a, grid_b);


module shields(side, height, g) {
    for(t = g) {
        translate(t)
//            smooth_hex(side,height);
              hexagon(side, height);
    }   
}


module web(side, scale, height, g) {
    for(t = g) {
        translate(t) 
            net(side,scale, height);
    }
}






