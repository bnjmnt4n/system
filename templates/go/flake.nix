{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
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
          vendorHash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
        };
      in
      {
        packages.${system}.default = package;
        devShells.${system}.default = pkgs.mkShell {
          buildInputs = [
            pkgs.go
            pkgs.gopls
          ];
        };
      });
}
