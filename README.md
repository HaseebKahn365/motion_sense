# Accident Detection and 3D Visualization Application

## Project Overview

This application is designed for accident detection using mobile device sensors. It utilizes gyroscope and compass data to detect 3D tilt and rotation, along with precise location tracking to monitor translational motion in space.

## Key Features

- **3D Tilt Control**: Manipulate a 3D model's tilt (right, left, forward, back) using four sliders.
- **Directional Rotation**: Rotate the model between 0 and 360 degrees using compass data and a slider interface.
- **3D Translation**: Control the model's position in 3D space using sliders for X, Y, and Z axes.

## Technical Implementation

- The application is developed using Flutter.
- 3D model manipulation is achieved using the `flutter_cube` package.
- Compass functionality is implemented with the `flutter_compass` package.

## User Interface

The home screen features three navigation buttons corresponding to the main functionalities: 3D Tilt, Direction Rotation, and 3D Translation. Each button leads to a dedicated screen for the respective control mechanism.

This project serves as a foundation for developing more advanced accident detection systems by simulating and visualizing various motion scenarios.
"""