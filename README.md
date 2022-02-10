# brucelib

**WARNING: WORK IN PROGRESS**

A monorepo of modules for developing cross-platform games, simulations and other applications. Leveraging the [Zig programming language and toolchain](https://ziglang.org/), brucelib intends to be highly hackable and suitable for rapid prototyping, jams or fully-fledged products. Each module can be used independently of, or in concert with the others and each can be extended or modified to your own specific needs.

"Absorb what is useful, discard what is useless and add what is specifically your own” - Bruce Lee


### Modules
| Name | Description | Status |
| :--- | :---------- | :----- |
| build | Useful build and distribution packaging procedures to import into your build.zig | planned |
| core | Minimal set of common types and functions used by other modules | in-progress |
| platform | Platform abstraction for windowing, graphics context creation, input, audio playback, network and file system procedures | in-progress |
| graphics | Push-style graphics API, abstracts low-level graphics backends | in-progress |
| lmathz | Linear math operators, functions and transforms commonly used for 3d graphics | in-progress |
| gui | Versatile gui library with an immediate-mode interface | planned |
| audio | Audio mixing, synthesis and signal processsing | planned |
| asset | Data-agnostic, graph-based asset system | planned |
| algo | Implementations of commonly used algorithms in games and simulations | planned |
| noise | Various noise generators | planned |


### Platform support
Many modules have no system dependencies and will just work on many targets thanks to Zig's awesome portabilty. Platform support for the `platform` and `graphics` modules will be somewhat more limited and currently the planned scope of this project is to target all the popular "native" desktop, mobile and console platforms.

Console backends for the `platform` and `graphics` modules are planned but will not provided by this repository. Access will be granted to registered NDA'd developers on request.

Cross-building to all supported target platforms from popular dev environments is planned.

TODO: Platform-target support matrix


## Getting Started
- Copy/clone/submodule this respository
- Grab external libraries with `git submodule update --init --recursive`
- Build and run an example: e.g. `zig build run-example-001`
- Run the tests with `zig build test`
- Print all build targets with `zig build --help`
- Each module has a main.zig, i.e. `/{module_name}/main.zig`. Import in your source or add as a package in your build.zig
