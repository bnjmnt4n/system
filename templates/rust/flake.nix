{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=63678e9f3d3afecfeafa0acead6239cdb447574c";
    flake-utils.url = "github:numtide/flake-utils?rev=ff7b65b44d01cf9ba6a71320833626af21126384";
    naersk.url = "github:nmattia/naersk";
    mozillapkgs = {
      url = "github:mozilla/nixpkgs-mozilla";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, naersk, mozillapkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        mozilla = pkgs.callPackage (mozillapkgs + "/package-set.nix") { };
        rust-channel = mozilla.rustChannelOf {
          channel = "1.66.0";
          sha256 = "sha256-S7epLlflwt0d1GZP44u5Xosgf6dRrmr8xxC+Ml2Pq7c=";
        };
        rust = rust-channel.rust;
        rust-src = rust-channel.rust-src;

        naersk-lib = naersk.lib."${system}".override {
          cargo = rust;
          rustc = rust;
        };

        nativeBuildInputs = with pkgs; [ openssl pkg-config ];
        buildInputs = [ ];
      in
      rec {
        packages.package = naersk-lib.buildPackage {
          pname = "package";
          root = ./.;
          inherit nativeBuildInputs buildInputs;
        };
        defaultPackage = packages.package;

        apps.package = flake-utils.lib.mkApp {
          drv = packages.package;
        };
        defaultApp = apps.package;

        devShell = pkgs.mkShell {
          inherit nativeBuildInputs;
          buildInputs = [
            rust
            pkgs.rust-analyzer
            pkgs.rustfmt
          ] ++ buildInputs;
          RUST_SRC_PATH = "${rust-src}/lib/rustlib/src/rust/library";
          RUST_LOG = "info";
          RUST_BACKTRACE = 1;
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
        };
      });
}
