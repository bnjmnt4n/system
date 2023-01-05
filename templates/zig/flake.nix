# TODO: setup zls.
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=12363fb6d89859a37cd7e27f85288599f13e49d9";
    flake-utils.url = "github:numtide/flake-utils?rev=7e2a3b3dfd9af950a856d66b0a7d01e3c18aa249";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, zig }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in {
       devShell = pkgs.mkShell {
          buildInputs = [
            zig.packages."${system}"."0.10.0"
          ];
        };
      });
}
