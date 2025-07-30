# Poncho - Hexagonal Grid Generator

A modular OpenSCAD project for generating complex hexagonal grid patterns and structures. This project creates customizable hexagonal meshes, plates, and geometric patterns that can be used for 3D printing, architectural models, or mathematical visualizations.

## Overview

Poncho is a collection of OpenSCAD modules that work together to create sophisticated hexagonal grid systems. The project includes:

- **Hexagonal Grid Generation**: Creates regular and offset hexagonal patterns
- **Mesh Structures**: Generates interconnected hexagonal networks
- **Plate Systems**: Creates solid hexagonal plates with embedded mesh patterns
- **Geometric Utilities**: Provides smooth hexagons, connectors, and various geometric operations

## Features

- **Modular Design**: Each component is separated into logical files for easy customization
- **Configurable Parameters**: Adjustable hexagon size, gaps, grid dimensions, and heights
- **Multiple Pattern Types**: Support for different hexagonal arrangements and connections
- **Smooth Geometry**: Includes smooth hexagon generation for organic-looking structures
- **Grid Systems**: Both regular and offset hexagonal grid patterns

## File Structure

```
poncho/
├── all.scad          # Main entry point - renders both plate and mesh
├── base.scad         # Core modules and functions
├── hexgrid.scad      # Advanced hexagonal grid utilities
├── hex.scad          # Basic hexagonal geometry
├── grid.scad         # Grid generation functions
├── plates.scad       # Plate generation module
├── mesh.scad         # Mesh generation module
└── blobs.scad        # Smooth hexagonal blob generation
```

## Usage

### Basic Usage

1. Open `all.scad` in OpenSCAD
2. Adjust parameters in `base.scad` as needed:
   - `hexagon_side`: Length of hexagon sides (default: 20)
   - `gap`: Gap between hexagons (default: 1)
   - `rows`: Number of rows (default: 4)
   - `cols`: Number of columns (default: 4)
   - `h`: Height of structures (default: 15)
   - `scale`: Scale factor for mesh (default: 1.2)

3. Render the model to generate both plate and mesh structures

### Individual Components

#### Generate Only Plates
```openscad
include <plates.scad>
plate();
```

#### Generate Only Mesh
```openscad
include <mesh.scad>
mesh();
```

#### Custom Grid Pattern
```openscad
include <base.scad>
// Create custom grid coordinates
custom_grid = [[0,0], [1,1], [2,0], [1,-1]];
web(10, 1.2, 5, custom_grid);
```

## Key Modules

### `plate()`
Generates a solid hexagonal plate with embedded mesh pattern. The plate uses a warm color (`#f7f1c8`) and includes a web pattern cut into the surface.

### `mesh()`
Creates a standalone mesh structure in cool blue (`#c8f3f7`). The mesh consists of interconnected hexagonal cells with connecting legs.

### `web(side, scale, height, grid)`
Generates a web-like structure with hexagonal nodes connected by legs. Automatically determines which connections to create based on grid boundaries.

### `cell(side, height, up, left, right)`
Creates individual hexagonal cells with optional connecting legs in three directions (up, left, right).

### `smooth_hex(R, r)`
Generates smooth, rounded hexagons using hull operations and spheres for organic geometry.

## Parameters

### Grid Configuration
- `hexagon_side`: Size of hexagon sides (mm)
- `gap`: Spacing between hexagons (mm)
- `rows`: Number of rows in the grid
- `cols`: Number of columns in the grid

### Structure Parameters
- `h`: Height of the structures (mm)
- `scale`: Scale factor for mesh elements
- `fancy`: Enable advanced features in shields module

### Color Settings
- Plate color: `#f7f1c8` (warm beige)
- Mesh color: `#c8f3f7` (cool blue)

## Examples

### Basic 4x4 Grid
```openscad
hexagon_side = 20;
gap = 1;
rows = 4;
cols = 4;
h = 15;
```

### Large Scale Pattern
```openscad
hexagon_side = 30;
gap = 2;
rows = 8;
cols = 8;
h = 25;
scale = 1.5;
```

### Fine Detail Pattern
```openscad
hexagon_side = 10;
gap = 0.5;
rows = 12;
cols = 12;
h = 8;
scale = 1.1;
```

## Requirements

- **OpenSCAD**: Version 2019.05 or later recommended
- **Hardware**: Sufficient RAM for complex grid operations (4GB+ recommended for large grids)

## Tips

1. **Performance**: Large grids (10x10+) may take significant time to render
2. **Printing**: Consider layer height and support requirements for 3D printing
3. **Customization**: Modify colors by changing the `color()` statements in the modules
4. **Scaling**: Use the `scale` parameter to adjust mesh density relative to plate size

## License

This project is open source. Feel free to modify and distribute according to your needs.

## Contributing

Contributions are welcome! Consider adding:
- New geometric patterns
- Additional color schemes
- Performance optimizations
- Documentation improvements

---

*Poncho - Creating beautiful hexagonal patterns with OpenSCAD* 