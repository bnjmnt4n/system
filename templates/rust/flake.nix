{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=d87b72206aadebe6722944f541f55d33fd7046fb";
    flake-utils.url = "github:numtide/flake-utils?rev=74f7e4319258e287b0f9cb95426c9853b282730b";
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
          date = "2021-05-20";
          channel = "nightly";
          sha256 = "aamsvtsiO6f+SrThu2yudNAVqUShKUIDnocMsTGUo3A=";
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
