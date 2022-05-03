# brucelib

**WARNING: WORK IN PROGRESS**

A monorepo of [modules](#modules) for programming cross-platform, interactive, real-time applications such as games, simulations, engines and editors. Leveraging the [Zig programming language and toolchain](https://ziglang.org/), brucelib intends to be highly hackable and suitable for rapid prototyping, jams or fully-fledged products. [The examples](#examples) demonstrate how one can use modules in combination with each other.

"Absorb what is useful, discard what is useless and add what is specifically your own” - Bruce Lee


### Modules

Modules are designed to be used standalone or in combination with each other. 3rd-party code is vendored and no external dependencies are required. Except for [platform](modules/platform/) and [graphics](modules/graphics/), modules have no system dependencies. The planned scope of this project is to target all the popular desktop, mobile and console platforms. However, current support is limited to Windows and Linux. All you need is [Zig 0.10.x](https://github.com/ziglang/zig).

| Module name | Description | Status |
| :--- | :---------- | :----- |
| [platform](modules/platform/) | Platform abstraction for windowing, graphics context creation, input, audio playback, network and file system procedures | in-progress |
| [graphics](modules/graphics/) | Graphics API abstraction, a higher-level `DrawList` API and various rendering primitives | in-progress |
| [audio](modules/audio/) | Mixing, synthesis, signal processsing and file loaders | in-progress |
| gui | A flexible gui library with an immediate-mode interface | planned |
| asset | Data-agnostic, graph-based asset system | planned |
| algo | Implementations of commonly used algorithms in games and simulations | planned |
| build | Useful build and distribution packaging procedures to import into your build.zig | planned |


## Getting Started
- Copy/clone/submodule this respository
- Run all the tests with `zig build test`
- Build and run an example: e.g. `zig build run-example-000`
- List all available build targets with `zig build --help`
- Each module has a main.zig, i.e. `modules/{module_name}/main.zig`. Import in your source or build and link in your build.zig. See [build.zig](build.zig) for examples.


### Examples

| Example | Screen capture |
| ------- | -------------- |
| [000-funky triangle](examples/000_funky_triangle/): A basic demonstration of how to use the [platform](modules/platform/) and [graphics](modules/graphics/) modules to open a window, draw stuff in it and output some audio | <img src="examples/000_funky_triangle/screencap.gif" width=426/> |


## Contributing

Feature requests, bug reports and pull requests are most welcome. Please note however, that this project is in early stages of development.

To contribute code, you must have sole ownership or have permission from an employer, client or partner where applicable and agree to license the contributed code under the license of this project as described in the [LICENSE](LICENSE) file.

TODO: CLA


## Licenses and attribution

Each module comes with a NOTICE file with license attributions for module code and 3rd-party vendored libraries. Care has been taken to adhere to the licenses of all 3rd-party code and give proper attribution where required. The contents of module's NOTICE file must be preserved in projects that use it. Alternatively, an umbrella [NOTICE](NOTICE) is provided that covers the entire monorepo.
