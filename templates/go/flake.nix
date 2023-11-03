{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=90e85bc7c1a6fc0760a94ace129d3a1c61c3d035";
    flake-utils.url = "github:numtide/flake-utils?rev=ff7b65b44d01cf9ba6a71320833626af21126384";
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
