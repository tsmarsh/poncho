sqrt3 = sqrt(3);

pattern  =  [       
                     [0,0], [1,0], [2,0], 
                     [0,1],        [2,1], [3,1],
             [-1, 2],[0,2], [1,2], [2,2],
                     [0,3],        [2,3],
                    ];

                    
//neighbours = [[1,0], [1, -1], [0, -1],
//              [-1,0], [-1,+1], [0, 1]];
              
 
 neighbours = [[1, 0], [-1,0], [0, 1]];
              
function x(q, r) = 1.5 * q;
 
 
function y(q, r) = sqrt3 * r + ((sqrt3 /2) * (q % 2));
    

function hexToCart(q, r) = [x(q,r), y(q,r), 0];

function hexPattern(coords) = [for (hc = coords) hexToCart(hc[0], hc[1])];

function hex_points(rad) = [for(i = [0:60:300]) [rad * cos(i), rad * sin(i)]];

function scale(x, list) = [for (i = list) [x[0] * i[0], x[1] * i[1], x[2] * i[2]]];

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

module star(side, l, h) {    
    connector(side, l,  h, 0);
    connector(side, l,  h, 60);
    connector(side, l, h, 120);
    connector(side, l,  h, 180);
    connector(side, l, h, 240);
    connector(side, l,  h, 300);

}


gap = 1;
side = 5;
height = 3;

rows = 3;
cols =8;
grid = [for(y = [0:1:rows]) for(x = [0:1:cols]) [x,y]];

strip = [for(y = [rows+1:1:rows+1]) for(x = [0:1:cols]) [x,y]];

grid2 = [for(y = [rows+2:1:rows+2+rows]) for(x = [0:1:cols]) [x,y]];

module shields(gap, side, height, pattern, cutout = false) {

    coords = scale([gap + side, gap + side,0], hexPattern(pattern));
    l = length(coords);
    
    for(t = coords) {
        translate(t) {
            difference() {
                hexagon(side, height, 1);
                 translate([0,0,height / 12])
                    star(side * 0.85, l, height * (5/6));
              if(cutout) {
                 translate([-side, -side ,height / 2])
                    cube(side * 2);
              }
            }
        }
    }
}

module mesh(gap, side, height, pattern, fancy = false) {
    coords = scale([gap + side, gap + side,0], hexPattern(pattern));
    
    l = length(coords);
        
    echo(coords);
    for(i = [0:1:len(coords)]) {
        if(fancy) {
            ns = [for(n = neighbours) [pattern[i].x + n.x, pattern[i].y + n.y]];
            echo(search(ns, pattern));
        }
        translate(coords[i]) {
            translate([0,0,height / 6])
                node(side * 0.8, l, height * (2/3));
        }
    }
}


color("blue", 1.0)
shields(gap, side, height, grid);
color("white", 1.0)
mesh(gap, side, height, grid);


color("red", 1.0)
shields(gap, side, height, strip, true);
color("black", 1.0)
mesh(gap, side, height, strip, false);

color("blue", 1.0)
shields(gap, side, height, grid2);
color("white", 1.0)
mesh(gap, side, height, grid2);

    //echo(search([[0,0], [0,1]], pattern));