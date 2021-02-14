{ lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "fluminurs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "fluminurs";
    repo = "fluminurs";
    rev = version;
    sha256 = "1xzs4zb3wwxn2wp6czq7nizp5id373g4p6r47yb73ma64hw95wq6";
  };

  cargoSha256 = "aFEKe5v0dTg82Fvwl6K7lYrE+S58iO7ybhy88r7QAnw=";

  nativeBuildInputs = [
    openssl
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
