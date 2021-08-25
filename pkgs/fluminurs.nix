{ src, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "fluminurs";
  version = "657708f451e9466fc7d957174ca3514c4f219ddc";
  inherit src;

  cargoSha256 = "sha256-9a062Qrn4s6ZsCYKBpbRAddz+Q+NJbsvtsgzHqs7aAk=";

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
