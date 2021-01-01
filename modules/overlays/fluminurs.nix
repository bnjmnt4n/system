{ lib, naersk, fetchFromGitHub, openssl, pkg-config, stdenv, ... }:

naersk.buildPackage rec {
  name = "fluminurs";
  version = "ebfbbbcb3a5ea2fc1ebb5563d2861558084eec36";

  src = fetchFromGitHub {
    owner = "indocomsoft";
    repo = "fluminurs";
    rev = version;
    sha256 = "1xbpbwfvj0hxdhi195j9anyv1rji9g0aczsjg7h52rvl8ddvvkq2";
  };

  buildInputs = [
    openssl
    pkg-config
  ];

  meta = with stdenv.lib; {
    description = "Luminus CLI";
    homepage = https://github.com/indocomsoft/fluminurs;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
