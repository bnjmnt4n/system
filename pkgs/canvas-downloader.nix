{ src, lib, stdenv, rustPlatform, fetchFromGitHub, openssl, pkg-config, Security }:

rustPlatform.buildRustPackage rec {
  pname = "canvas-downloader";
  version = src.rev;
  inherit src;

  cargoSha256 = "sha256-x1+SjrgZLVk0Sxwsz2c+Cg/MfqQwhXknU+FWFg96T20=";

  cargoBuildFlags = [];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Downloads files from all courses in canvas.";
    homepage = "https://github.com/k-walter/canvas-downloader";
    platforms = platforms.all;
  };
}
