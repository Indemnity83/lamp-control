# Lamp Control

This repository contains the KiCad project files for the **Lamp Control** circuit.

## Overview

This project provides open hardware design files for a lamp control board based on the ESP-12E module. All schematic, PCB, and manufacturing assets are generated using [KiCad](https://kicad.org/).

## Schematic

![Schematic](docs/schematic.svg)

## PCB Render

![PCB Render](docs/board.png)

## Build Assets

- Gerber files, BOM, pick-and-place, and PDF schematic are generated in the `build/` directory by running:

  ```sh
  make build
  ```

- Manufacturing assets are available as [GitHub Releases](https://github.com/indemnity83/lamp-control/releases) or workflow artifacts.

## License

This project is open hardware. See [LICENSE](LICENSE) for details.