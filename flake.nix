{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    utils.url = "github:numtide/flake-utils";
    zig.url = "github:arqv/zig-overlay";
  };

  outputs = { self, nixpkgs, utils, zig }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in {
       devShell = with pkgs; mkShell {
          nativeBuildInputs = [
            zig.packages."${system}".master.latest
            buildPackages.xlibsWrapper
            buildPackages.xorg.libX11
            buildPackages.xorg.libXrandr
            buildPackages.libGL
            buildPackages.alsa-lib
          ];
        };
      });
}
