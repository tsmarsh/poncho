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