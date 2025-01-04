{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
      forEachSystem = systems: f: builtins.foldl' (acc: system: nixpkgs.lib.recursiveUpdate acc (f system)) {} systems;
    in
    forEachSystem systems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        package = pkgs.buildGoModule {
          pname = "package";
          version = "0.0.0";
          src = pkgs.lib.cleanSource ./.;
          vendorHash = nixpkgs.lib.fakeSha256;
        };
      in
      {
        packages.${system}.default = package;
        devShells.${system}.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            gopls
          ];
        };
      });
}
