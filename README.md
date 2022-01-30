# brucelib

WORK IN PROGRESS

A monorepo of modules for developing cross-platform games, simulations and media-rich applications, leveraging the [Zig programming language and toolchain](https://ziglang.org/). Designed to be hackable and suitable for rapid prototyping, jams or fully-fledged products. Each module can be used independently of, or in concert with the others and each can be extended or modified to your own specific needs.

"Absorb what is useful, discard what is useless and add what is specifically your own” - Bruce Lee


## Modules
- `core`: minimal set of common types and functions used by other modules
- `platform`: platform abstraction for windowing, graphics context creation, input, audio playback, network and file system procedures
- `graphics`: push-style graphics API, abstracts low-level graphics backends
- `gui`: versatile gui library with an immediate-mode interface
- `audio`: audio mixing, synthesis and signal processsing
- `asset`: data-agnostic, graph-based asset system and loading & saving procedures for common formats
- `algo`: implementations of commonly used algorithms in games and simulations
- `noise`: various noise generators


## Supported platforms 
Many modules have no system dependencies and will just work on many targets thanks to Zig's awesome portabilty. Platform support for the `platform` and `graphics` modules will be somewhat more limited and currently the planned scope of this project is to target all the popular "native" desktop, mobile and console platforms.

Console backends for the `platform` and `graphics` modules are planned but will not provided by this repository. Access will be granted to registered NDA'd developers on request.

Cross-building to all supported target platforms from popular dev environments is planned.

TODO: Platform-target support matrix


## Getting Started
TODO
