{ lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "fluminurs";
  version = "657708f451e9466fc7d957174ca3514c4f219ddc";

  src = fetchFromGitHub {
    owner = "bnjmnt4n";
    repo = "fluminurs";
    rev = version;
    sha256 = "sha256-fIZ3ZpZdF7gebhy4y0CSOutuiVwWhO1gvkIH8/jDsgg=";
  };

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
