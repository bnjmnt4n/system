{ lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "fluminurs";
  version = "3c461078047dd2e645a4080d3179d676a2c4fea5";

  src = fetchFromGitHub {
    owner = "fluminurs";
    repo = "fluminurs";
    rev = version;
    sha256 = "Y51NYYSfuPW8vqy+kIByfPUbnHgZpTwkD0OrjL9vT3A=";
  };

  cargoSha256 = "kYAVlBnYN8uRUt0Y/XIYwmgs5WTMly7A9znanT1OR6Y=";

  cargoBuildFlags = [
    "--bin"
    "fluminurs-cli"
    "--features=\"cli\""
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
