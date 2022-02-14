# brucelib

**WARNING: WORK IN PROGRESS**

A monorepo of modules for programming cross-platform games, simulations, engines and editors. Leveraging the [Zig programming language and toolchain](https://ziglang.org/), brucelib intends to be highly hackable and suitable for rapid prototyping, jams or fully-fledged products. Each module is designed to be easy to configure, extend or modify to your own specific needs. The examples demonstrate how one can use modules in combination with each other.

"Absorb what is useful, discard what is useless and add what is specifically your own” - Bruce Lee


### Modules
| Name | Description | Status |
| :--- | :---------- | :----- |
| build | Useful build and distribution packaging procedures to import into your build.zig | planned |
| [core](modules/core/) | Minimal set of common types and functions used by other modules | in-progress |
| [platform](modules/platform/) | Platform abstraction for windowing, graphics context creation, input, audio playback, network and file system procedures | in-progress |
| [graphics](modules/graphics/) | Push-style graphics API abstracting low-level graphics backends, high level primitives and builtin renderers | in-progress |
| gui | Versatile gui library with an immediate-mode interface | planned |
| audio | Audio mixing, synthesis and signal processsing | planned |
| asset | Data-agnostic, graph-based asset system | planned |
| algo | Implementations of commonly used algorithms in games and simulations | planned |
| noise | Various noise generators | planned |


### Supported targets
The planned scope of this project is to target all the popular desktop, mobile and console platforms. Most modules have no system dependencies. Refer to the [platform](modules/platform/) and [graphics](modules/graphics) module documentation for more information.


## Getting Started
- Copy/clone/submodule this respository
- Grab external libraries with `git submodule update --init --recursive`
- Build and run an example: e.g. `zig build run-example-001`
- Run the tests with `zig build test`
- Print all build targets with `zig build --help`
- Each module has a main.zig, i.e. `/{module_name}/main.zig`. Import in your source or add as a package in your build.zig

### Examples

[001-funky-triangle](examples/001_funky_triangle/)
