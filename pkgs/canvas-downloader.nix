{ src, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "canvas-downloader";
  version = src.rev;
  inherit src;

  cargoSha256 = "sha256-OOTAfBuhjzh+UHgq34DyVucNvFZa7TV9HsXg5zYOYVU=";

  cargoBuildFlags = [];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Downloads files from all courses in canvas.";
    homepage = "https://github.com/k-walter/canvas-downloader";
    platforms = platforms.all;
  };
}
