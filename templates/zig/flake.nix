{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=d87b72206aadebe6722944f541f55d33fd7046fb";
    flake-utils.url = "github:numtide/flake-utils?rev=74f7e4319258e287b0f9cb95426c9853b282730b";
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
