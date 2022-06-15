# brucelib

**WARNING: WORK IN PROGRESS**

A monorepo of [modules](#modules) for programming cross-platform, interactive, real-time applications such as games, simulations, engines and editors.

The planned scope of this project is to target all the popular desktop, mobile and console platforms. While most modules have no system dependencies; the [platform](modules/platform) module is currently limted to Linux and Windows and the [graphics](modules/graphics) module is limited to OpenGL 4.4+ and D3D11. More backends are planned and the modules are designed to make adding new backends fairly trivial.

Requires [Zig 0.10.x](https://github.com/ziglang/zig).


### Modules

Modules are designed to be used standalone or in combination with each other (see [examples](#examples)). 3rd-party code is vendored and no external dependencies are required.

- [platform](modules/platform/) - Platform abstraction for windowing, graphics context creation, input, audio playback, network and file system procedures (in-progress)
- [graphics](modules/graphics/) - Graphics API abstraction, a higher-level `DrawList` API and various rendering primitives (in-progress)
- [audio](modules/audio/) - Mixing, synthesis, signal processsing and file loaders (in-progress)
- [algo](modules/algo/) - Various algorithms used in games and simulations (in-progress)
- *gui* - A flexible gui library (planned)
- [util](modules/util/) - [Tracy Profiler](https://github.com/wolfpld/tracy) via [zig-gamedev's ztracy](https://github.com/michal-z/zig-gamedev/tree/main/libs/ztracy) and other dev, test and deployment utilities (in-progress)


## Getting Started
- Copy/clone/submodule this respository
- Run all the tests with `zig build test`
- Build and run an example: e.g. `zig build run-example-000`
- List all available build targets with `zig build --help`
- Each module has a build.zig (`modules/{module_name}/build.zig`) that exposes a `std.build.Pkg` and a `link` fn. See [build.zig](build.zig) for examples.

Alternatively, take a look at [this project template](https://github.com/hazeycode/brucelib-begin)

### Profiling

To use the [Tracy Profiler](https://github.com/wolfpld/tracy) integration via [zig-gamedev's ztracy](https://github.com/michal-z/zig-gamedev/tree/main/libs/ztracy):

`zig build -Dztracy-enable=true`

### Examples

| Example | Screen capture |
| ------- | -------------- |
| [000-funky-triangle](examples/000-funky-triangle/): A basic demonstration of how to use the [platform](modules/platform/) and [graphics](modules/graphics/) modules to open a window, draw stuff in it and output some audio | <img src="examples/000-funky-triangle/screencap.gif" width=213/> |
| 001-2d-tile-platformer: A simple 2d game and introduces the [audio module](modules/audio/) which is used to play SFX and music | in-progress |

## Contributing

Feature requests, bug reports and pull requests are most welcome. Please note however, that this project is in very early stages of development and everything may change.


## Licenses and attribution

Each module comes with a NOTICE file with license attributions for module code and 3rd-party vendored libraries. Care has been taken to adhere to the licenses of all 3rd-party code and give proper attribution where required. The contents of module's NOTICE file must be preserved in projects that use it. Alternatively, an umbrella [NOTICE](NOTICE) is provided that covers the entire monorepo.
