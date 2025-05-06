# Global-WindFlow-Mapping
WindFlowAnalyzer is a powerful tool that simulates and analyzes global wind patterns, providing a comprehensive view of wind dynamics across various regions. 

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Demo](#demo)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Usage](#usage)
- [Code Structure](#code-structure)
- [Parameters](#parameters)
- [Authors](#authors)
- [License](#license)

## Project Overview
This project, developed on November 23, 2024, visualizes global wind flow patterns on a world map using the [Processing](https://processing.org/) framework. It leverages wind data from a JSON file, employing bilinear interpolation to simulate wind direction and magnitude through animated particles. The visualization includes a color-coded overlay representing wind intensity, providing an intuitive representation of meteorological data for educational and analytical purposes.

## Features
- **Dynamic Particle Animation**: Simulates wind flow with 30,000 particles, each following interpolated wind vectors for realistic motion.
- **Bilinear Interpolation**: Ensures smooth transitions in wind vector calculations, enhancing the accuracy of particle movement.
- **Color-Coded Wind Magnitude**: Visualizes wind intensity with a gradient (blue for low, transitioning to green, yellow, and red for higher magnitudes).
- **Scalable Map Rendering**: Adjusts the wind field to fit the canvas resolution, maintaining accuracy across different dimensions.
- **Efficient Data Processing**: Loads and processes large JSON datasets containing wind component data (X and Y components).

## Demo
The Wind Flow Visualization produces a dynamic, animated display of global wind patterns overlaid on a world map. Below is a conceptual description of the output, as the project generates real-time animations that are best experienced by running the sketch:

- **Visual Output**: The visualization renders a 1400x700 pixel window displaying a world map (`world_map.png`) as the background. Approximately 30,000 particles move across the map, tracing wind trajectories derived from the `wind_conditions.json` dataset. Each particle’s path is drawn using smooth Bézier curves, creating flowing, stream-like patterns that mimic real-world wind currents.
- **Color Coding**: Wind magnitude is represented by colored points overlaid on the map:
  - **0–5 m/s**: Blue to green, indicating calm to moderate winds (e.g., over oceans or plains).
  - **5–7 m/s**: Green to yellow, showing stronger breezes (e.g., coastal regions).
  - **7–10 m/s**: Yellow to red, highlighting high wind speeds (e.g., storm-prone areas).
  - Particle transparency adjusts dynamically, with lower magnitudes appearing more transparent and higher magnitudes more opaque.
- **Animation Details**: Particles reset to random positions upon reaching their lifespan (100 milliseconds) or exiting the canvas, ensuring continuous motion. The animation runs at a smooth frame rate, with particles updating their positions based on interpolated wind vectors, creating a fluid, meteorological simulation.

https://github.com/user-attachments/assets/0601f89b-378c-43e1-94d0-f87c84b7c07f

**Provided Assets**:
If you do not have `world_map.png` or `wind_conditions.json`, sample files are provided in the repository’s `data/` folder. The `world_map.png` is a 1400x700 pixel public domain map, and `wind_conditions.json` contains sample wind data formatted as required. The JSON file must follow this structure:

```json
[
    {

        "header": {
            "discipline": 0,
            "disciplineName": "Meteorological products",
            "gribEdition": 2,
            "gribLength": 79010,
            "center": 7,
            "centerName": "US National Weather Service - NCEP(WMC)",
            "subcenter": 0,
            "refTime": "2024-10-21T18:00:00.000Z",
            "significanceOfRT": 1,
            "significanceOfRTName": "Start of forecast",
            "productStatus": 0,
            "productStatusName": "Operational products",
            "productType": 1,
            "productTypeName": "Forecast products",
            "productDefinitionTemplate": 0,
            "productDefinitionTemplateName": "Analysis/forecast at horizontal level/layer at a point in time",
            "parameterCategory": 2,
            "parameterCategoryName": "Momentum",
            "parameterNumber": 2,
            "parameterNumberName": "U-component_of_wind",
            "parameterUnit": "m.s-1",
            "genProcessType": 2,
            "genProcessTypeName": "Forecast",
            "forecastTime": 0,
            "surface1Type": 103,
            "surface1TypeName": "Specified height level above ground",
            "surface1Value": 10.0,
            "surface2Type": 255,
            "surface2TypeName": "Missing",
            "surface2Value": 0.0,
            "gridDefinitionTemplate": 0,
            "gridDefinitionTemplateName": "Latitude_Longitude",
            "numberPoints": 65160,
            "shape": 6,
            "shapeName": "Earth spherical with radius of 6,371,229.0 m",
            "gridUnits": "degrees",
            "resolution": 48,
            "winds": "true",
            "scanMode": 0,
            "nx": 360,
            "ny": 181,
            "basicAngle": 0,
            "lo1": 0.0,
            "la1": 90.0,
            "lo2": 359.0,
            "la2": -90.0,
            "dx": 1.0,
            "dy": 1.0
        },
        "data": [
            -5.9910207,
            -6.0110207,
            -6.0210204,
            ...
        ]
    },
    {
        "header": {
            "discipline": 0,
            "disciplineName": "Meteorological products",
            "gribEdition": 2,
            "gribLength": 79360,
            "center": 7,
            "centerName": "US National Weather Service - NCEP(WMC)",
            "subcenter": 0,
            "refTime": "2024-10-21T18:00:00.000Z",
            "significanceOfRT": 1,
            "significanceOfRTName": "Start of forecast",
            "productStatus": 0,
            "productStatusName": "Operational products",
            "productType": 1,
            "productTypeName": "Forecast products",
            "productDefinitionTemplate": 0,
            "productDefinitionTemplateName": "Analysis/forecast at horizontal level/layer at a point in time",
            "parameterCategory": 2,
            "parameterCategoryName": "Momentum",
            "parameterNumber": 3,
            "parameterNumberName": "V-component_of_wind",
            "parameterUnit": "m.s-1",
            "genProcessType": 2,
            "genProcessTypeName": "Forecast",
            "forecastTime": 0,
            "surface1Type": 103,
            "surface1TypeName": "Specified height level above ground",
            "surface1Value": 10.0,
            "surface2Type": 255,
            "surface2TypeName": "Missing",
            "surface2Value": 0.0,
            "gridDefinitionTemplate": 0,
            "gridDefinitionTemplateName": "Latitude_Longitude",
            "numberPoints": 65160,
            "shape": 6,
            "shapeName": "Earth spherical with radius of 6,371,229.0 m",
            "gridUnits": "degrees",
            "resolution": 48,
            "winds": "true",
            "scanMode": 0,
            "nx": 360,
            "ny": 181,
            "basicAngle": 0,
            "lo1": 0.0,
            "la1": 90.0,
            "lo2": 359.0,
            "la2": -90.0,
            "dx": 1.0,
            "dy": 1.0
        },
        "data": [
            -1.0850537,
            -0.9850537,
            -0.8750537,
            ...
        ]
    }
]
```

Ensure any custom `wind_conditions.json` adheres to this structure, with two objects: one for the U-component (X) and one for the V-component (Y) of wind, each containing a `header` with grid metadata and a `data` array of wind values.

## Dependencies
- **Processing**: Version 3.5.4 or later is recommended for compatibility. Download from [processing.org](https://processing.org/download/).
- **Input Files**:
  - `wind_conditions.json`: A JSON file containing wind component data (X and Y) and metadata (grid dimensions: `nx`, `ny`, `numberPoints`). A sample file is provided in the repository’s `data/` folder.
  - `world_map.png`: A high-resolution world map image (1400x700 pixels by default) for the background. A sample file is provided in the repository’s `data/` folder. Alternatively, source a public domain map from [Natural Earth](https://www.naturalearthdata.com/downloads/10m-raster-data/10m-natural-earth-1/).
- **Hardware**: A system with moderate graphical capabilities (e.g., a modern CPU, at least 8GB RAM, and a dedicated GPU recommended) to render 30,000 animated particles smoothly.
- **Operating System**: Compatible with Windows, macOS, or Linux, as supported by Processing.

## Installation
1. **Install Processing**:
   - Download the latest version of Processing from [processing.org](https://processing.org/download/).
   - Follow the installation instructions for your operating system:
     - **Windows**: Run the installer and follow prompts.
     - **macOS**: Drag the Processing app to the Applications folder.
     - **Linux**: Extract the tarball and run the `processing` executable.
   - Verify the installation by launching the Processing IDE and running a sample sketch (e.g., `File > Examples > Basics > Shape > Vertices`).
2. **Prepare Input Files**:
   - Use the provided `wind_conditions.json` and `world_map.png` in the repository’s `data/` folder, or prepare custom files.
   - If creating a custom `wind_conditions.json`, ensure it follows the structure shown in the [Demo](#demo) section. Sample datasets can be sourced from meteorological APIs or open datasets like [NOAA’s GFS](https://www.nco.ncep.noaa.gov/pmb/products/gfs/).
   - If using a custom `world_map.png`, ensure it is 1400x700 pixels. Resize or crop a map from [Natural Earth](https://www.naturalearthdata.com/) if necessary using tools like GIMP or Photoshop.
   - Place both files in the `data/` folder within the Processing sketch directory. Create the `data/` folder if it does not exist.
3. **Clone or Download the Project**:
   - Clone this repository using:
     ```bash
     git clone <repository-url>
     ```
   - Alternatively, download the source code as a ZIP file from the repository and extract it to your preferred directory.
4. **Open in Processing**:
   - Launch the Processing IDE.
   - Open the `.pde` file (e.g., `WindFlowVisualization.pde`) from the project directory via `File > Open`.
   - Verify that the `data/` folder (containing `wind_conditions.json` and `world_map.png`) is correctly placed in the same directory as the `.pde` file.

## Usage
1. **Launch the Sketch**:
   - Click the "Run" button (play icon) in the Processing IDE to start the sketch.
   - The program initializes a 1400x700 pixel window displaying the world map with animated particles.
2. **Observe the Visualization**:
   - Particles move across the map, representing wind flow based on the `wind_conditions.json` data.
   - Colors indicate wind magnitude:
     - **Blue to Green**: 0–5 m/s (calm to moderate winds).
     - **Green to Yellow**: 5–7 m/s (stronger breezes).
     - **Yellow to Red**: 7–10 m/s (high wind speeds).
   - Particle transparency (50–255 alpha) and size (5–15 pixels) adjust dynamically based on wind intensity.
3. **Adjust Parameters** (Optional):
   - Modify `numberParticles` in the `setup()` function to change the number of animated particles (default: 30,000). Higher values (e.g., 50,000) increase density but may reduce performance on lower-end systems.
   - Adjust the canvas size in `size(width, height)` to change resolution (e.g., `size(1920, 1080)` for full HD). Ensure `world_map.png` matches the new dimensions to avoid scaling artifacts.
   - Edit the `initial_lifespan` in the `Particle` class to alter particle longevity (default: 100 milliseconds). Longer lifespans (e.g., 200) create longer trails but may clutter the display.
4. **Interact with the Visualization**:
   - The animation runs continuously, with particles resetting to random positions upon reaching their lifespan or exiting the canvas boundaries.
   - Use the Processing IDE’s controls to pause (Ctrl+T) or stop the sketch. Export frames as images via `saveFrame()` if needed for analysis.
   - For advanced users, integrate real-time wind data by updating `wind_conditions.json` from sources like [OpenWeatherMap](https://openweathermap.org/api) or [ECMWF](https://www.ecmwf.int/).

## Code Structure
- **Main Sketch**:
  - `setup()`: Initializes the canvas, loads wind data, computes scaling factors, and sets up particles.
  - `draw()`: Renders the world map and updates particle positions for animation.
  - `colorMap()`: Overlays colored points on the map to represent wind magnitude.
  - `computeScale()`: Calculates horizontal and vertical scaling factors (`XScale`, `YScale`) based on map dimensions.
  - `loadWindData()`: Parses `wind_conditions.json` to extract wind components and metadata.
  - `processVectors()`: Generates particles with properties derived from wind data.
  - Utility functions:
    - `computeMagnitude()`: Calculates wind speed using the Pythagorean theorem (`sqrt(X^2 + Y^2)`).
    - `computeAngle()`: Determines wind direction using `atan2`.
    - `interpolate()`: Performs bilinear interpolation for smooth wind vector transitions.
    - `getWindColor()`: Maps wind magnitude to a color gradient (blue to red).
- **Particle Class**:
  - Manages individual particle properties (position, magnitude, direction, lifespan).
  - Key methods:
    - `move()`: Updates particle position based on interpolated wind vectors.
    - `display()`: Renders particles using Bézier curves for smooth, curved trajectories.
    - `checkEdges()`: Resets particles that exit the canvas boundaries.
    - `resetParticle()`: Reinitializes particles with random properties upon lifespan expiration.

## Parameters
- **Particle Count**: 30,000 particles (configurable in `setup()` via `numberParticles`).
- **Canvas Resolution**: 1400x700 pixels (adjustable in `size()`).
- **Wind Data**: Sourced from `wind_conditions.json`, containing:
  - X and Y wind components (`componentX_Data`, `componentY_Data`) as `JSONArray`.
  - Grid dimensions (`nx`, `ny`, `numberPoints`) in the JSON header.
- **Color Mapping**:
  - 0–5 m/s: Blue to green (`RGB(0, 0–255, 255–0)`).
  - 5–7 m/s: Green to yellow (`RGB(0–255, 255, 0)`).
  - 7–10 m/s: Yellow to red (`RGB(255, 255–0, 0)`).
- **Particle Lifespan**: 100 milliseconds (configurable in `Particle` constructor via `initial_lifespan`).
- **Scaling Factors**: Computed dynamically (`XScale = width / columns`, `YScale = height / rows`) to map wind grid coordinates to canvas pixels.

## Authors
- **Alyson Melissa Sánchez Serratos** (A01771843)
- **Carlos Alberto Mejía Vergara** (A01364028)
- **Julieta Itzel Pichardo Meza** (A01369630)

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
