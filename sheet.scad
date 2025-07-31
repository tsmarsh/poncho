gap = 1;
side = 5;
height = 3;

rows = 20;
cols = 20;


sqrt3 = sqrt(3);              
 
neighbours = [[1, -1], [-1,-1], [0, 2]];

all_neighbours = [[0,2],[-1, 1], [-1, -1], [0, -2], [1, -1], [1,1]];
              
function x(q, r) = 1.5 * q;
 
 
function y(q, r) = (sqrt3 * r); //- (sqrt3 * (q % 2)) / 2;
    

function hexToCart(q, r) = [x(q,r), y(q,r), 0];

function hexPattern(coords) = [for (hc = coords) hexToCart(hc[0], hc[1])];

function hex_points(rad) = [for(i = [0:60:300]) [rad * cos(i), rad * sin(i)]];

function scale(x, list) = [for (i = list) [x.x * i.x, x.y / 2 * i.y, x.z * i.z]];

module hexagon(side, height, scale = 1.2) {
    linear_extrude(height = height, scale = scale)
    polygon(hex_points(side));
}


function head_points(rad) = [
    [0, 0],
    [rad * cos(60), rad * sin(60)],
    [rad * cos(120), rad * sin(120)]
];

module connector(side, l, h, i) {
    width = side / 3;
    tri_l = side * sqrt3;
    link_l = l - (2 * tri_l);
    
    rotate([0,0,i])
        linear_extrude(h)
            union() {
                color("blue")
                polygon(head_points(side));
                color("red")
                translate([-width / 2, tri_l / 2,0])
                    square([width, l- (tri_l)]);
                color("green", 1.0) {
                translate([0, l ,0])
                    rotate([0,0,180])
                        polygon(head_points(side));
                 }
        
            }
}

function length(coords) = norm([coords[0][0] - coords[1][0], coords[0][1] - coords[1][1], coords[0][2] - coords[1][2]]);

module node(side, l, h, neighbours = [true, true, true]) {
    if(neighbours[0]) connector(side, l,  h, 0);
    if(neighbours[1]) connector(side, l, h, 120);
    if(neighbours[2]) connector(side, l, h, 240);

}

module star(side, l, h, neighbours = [true, true, true, true, true, true, true]) {
    if(neighbours[0]) connector(side, l,  h, 0);
    if(neighbours[1]) connector(side, l,  h, 60);
    if(neighbours[2]) connector(side, l, h, 120);
    if(neighbours[3]) connector(side, l,  h, 180);
    if(neighbours[4]) connector(side, l, h, 240);
    if(neighbours[5]) connector(side, l,  h, 300);

}

grid_a = [for(y = [0:2:rows-1]) for(x = [0:2:cols-1]) [x,y]];
grid_b = [for(y = [1:2:rows-1]) for(x = [1:2:cols-1]) [x,y]];
grid = concat(grid_a, grid_b);



module shields(gap, side, height, pattern, cutout = false, fancy = false) {
    
    coords = scale([gap + side, gap + side,0], hexPattern(pattern));
    l = length(scale([gap + side, gap + side, 0], hexPattern([[0,0], [0,2]])));
    
    for(i = [0:1:len(coords)-1]) {
        translate(coords[i]) {
            difference() {
                hexagon(side, height, 1);
                if(fancy) {
                    ns = [for(n = all_neighbours) [pattern[i].x + n.x, pattern[i].y + n.y]];
                    s = search(ns, pattern);
                    translate([0,0,height / 12])
                        star(side * 0.85, l, height * (5/6), [is_num(s[0]), is_num(s[1]), is_num(s[2]), 
                                                              is_num(s[3]), is_num(s[4]), is_num(s[5])]);
                }else{
                    translate([0,0,height / 12])
                        star(side * 0.85, l, height * (5/6));
                }
            
              if(cutout) {
                 translate([-side, -side ,height / 2])
                    cube(side * 2);
              }
            }
        }
    }
}

module hexes(grid, side, height, pattern) {
    
    coords = scale([grid, grid,0], hexPattern(pattern));

    
    for(i = [0:1:len(coords)-1]) {
        translate(coords[i]) {
            hexagon(side, height, 1);
        }
    }
}

module mesh(gap, side, height, pattern, fancy = false) {
    coords = scale([gap + side, gap + side,0], hexPattern(pattern));
    
    l = length(scale([gap + side, gap + side, 0], hexPattern([[0,0], [0,2]])));
        
    for(i = [0:1:len(coords)-1]) {
        if(fancy) {
            ns = [for(n = neighbours) [pattern[i].x + n.x, pattern[i].y + n.y]];
            s = search(ns, pattern);
            translate(coords[i])
                translate([0,0,height / 6])
                    node(side * 0.8, l, height * (2/3), [is_num(s.z), is_num(s.y), is_num(s.x)]);
        } else {
            translate(coords[i]) {
                translate([0,0,height / 6])
                    node(side * 0.8, l, height * (2/3));
            }
        }

    }
}

echo(grid);

color("blue", 1.0)
union() {
difference() {
    hexes(gap+side, side, height, grid);
    translate([0,0,height / 2 - height / 8])
        hexes(gap+side, side+gap, height/3, grid);
}
hexes(gap+side, side/4, height, grid);
}

color("red", 1.0)
difference() {
    translate([0,0,height / 2 - height / 8])
        hexes(gap+side, side+gap, height/4, grid);
    hexes(gap+side, side/2, height, grid);

}



