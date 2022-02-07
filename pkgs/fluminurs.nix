{ src, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "fluminurs";
  version = src.rev;
  inherit src;

  cargoSha256 = "sha256-k4LRAAY1puqSBL8upZinBOVx4Y9bfj6IwGzqu6b9dQc=";

  cargoBuildFlags = [
    "--bin"
    "fluminurs-cli"
    "--features"
    "cli"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "A CLI client in Rust to access the reverse-engineered LumiNUS API";
    homepage = "https://github.com/fluminurs/fluminurs";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
