{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=04f574a1c0fde90b51bf68198e2297ca4e7cccf4";
    flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f";
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
