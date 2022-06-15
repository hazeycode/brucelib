# brucelib.trace

Provides some builtin Profilers that can be used with the other modules.

- `NullProfiler` can be used to disable profiling in modules that require a Profiler
- `ZtracyProfiler` is a wrapper around [ztracy](https://github.com/michal-z/zig-gamedev/tree/main/libs/ztracy)


### Vendored

Each vendored library is listed below with the license it is under; also see the [NOTICE](NOTICE) file.

| Name | Description | License |
| :--- | :---------- | :------ |
| [ztracy](src/vendored/ztracy) | [ztracy](https://github.com/michal-z/zig-gamedev/tree/main/libs/ztracy) is a Zig wrapper for the [Tracy Profiler](https://github.com/wolfpld/tracy) |MIT & BSD-3-Clause|
