{ src, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "canvas-downloader";
  version = src.rev;
  inherit src;

  cargoSha256 = "sha256-xxl7imvmWdbWEYqJRVmB9rIaKfC45Cm1Fek0Ux0jjyI=";

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
