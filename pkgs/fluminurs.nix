{ lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "fluminurs";
  version = "b516f6e79ee33a14fe11601d4ee1b0783b1b6d3e";

  src = fetchFromGitHub {
    owner = "fluminurs";
    repo = "fluminurs";
    rev = version;
    sha256 = "L8jna5lLm44pOobdtwKU4eIr16DbwLt35kk0jFkgCHg=";
  };

  cargoSha256 = "p0flRp2j6t5E0dIy96J/8IBj22EmSaXxfuPtcXZk5Ts=";

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
