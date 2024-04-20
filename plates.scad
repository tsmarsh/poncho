include <base.scad>

difference() { 
    color("#f7f1c8")
    shields(hexagon_side, h, g);
    translate([0,0,h/4])
        web(hexagon_side, scale, h/2, g);
}
