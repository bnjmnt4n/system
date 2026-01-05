{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
    forEach = list: f: builtins.foldl' (acc: item: nixpkgs.lib.recursiveUpdate acc (f item)) {} list;
  in
    forEach systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          emptyDirectory
        ];
      };
    });
}
