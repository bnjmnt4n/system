{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=04f574a1c0fde90b51bf68198e2297ca4e7cccf4";
    flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in {
       devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
          ];
        };
      });
}
