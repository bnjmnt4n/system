{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=12363fb6d89859a37cd7e27f85288599f13e49d9";
    flake-utils.url = "github:numtide/flake-utils?rev=7e2a3b3dfd9af950a856d66b0a7d01e3c18aa249";
    zig-overlay.url = "github:arqv/zig-overlay";
    zls = {
      url = "github:bnjmnt4n/zls";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, zig-overlay, zls }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        # Nix flakes are not fetched with submodules: 
        # https://github.com/NixOS/nix/issues/4423
        zlsWithSubmodules = builtins.fetchGit {
          url = "https://github.com/bnjmnt4n/zls.git";
          inherit (zls) rev;
          submodules = true;
        };
      in {
       devShell = pkgs.mkShell {
          buildInputs = [
            zig-overlay.packages."${system}".master.latest
            (import zlsWithSubmodules { inherit pkgs system; })
          ];
        };
      });
}
