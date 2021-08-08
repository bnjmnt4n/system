{ lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "fluminurs";
  version = "62c89f0c236b79d66b6503c0a87f2397319955f6";

  src = fetchFromGitHub {
    owner = "fluminurs";
    repo = "fluminurs";
    rev = version;
    sha256 = "L8jna5lLm44pOobdtwKU4eIr16DbwLt35kk0jFkgCHg=";
  };

  cargoSha256 = "sha256-ehbKGvIdBUrsLJgfsFnv6o4cHxdlaa/Sx8hbnsyONkc=/8IBj22EmSaXxfuPtcXZk5Ts=";

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
