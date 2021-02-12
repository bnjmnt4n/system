{ lib, naersk, fetchFromGitHub, openssl, pkg-config, ... }:

naersk.buildPackage rec {
  name = "fluminurs";
  version = "06ac5fc80f2223c3fa6de66288d0c074344338c0";

  src = fetchFromGitHub {
    owner = "fluminurs";
    repo = "fluminurs";
    rev = version;
    sha256 = "1xzs4zb3wwxn2wp6czq7nizp5id373g4p6r47yb73ma64hw95wq6";
  };

  buildInputs = [
    openssl
    pkg-config
  ];

  meta = with lib; {
    description = "Luminus CLI";
    homepage = https://github.com/fluminurs/fluminurs;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
