{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=85b081528b937df4bfcaee80c3541b58f397df8b";
    flake-utils.url = "github:numtide/flake-utils?rev=cfacdce06f30d2b68473a46042957675eebb3401";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        package = pkgs.buildGoModule {
          pname = "package";
          version = "0.0.0";
          src = pkgs.lib.cleanSource ./.;
          vendorHash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
        };
      in
      {
        packages.default = package;
        apps.default = flake-utils.lib.mkApp {
          drv = package;
        };
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.go
            pkgs.gopls
          ];
        };
      });
}
