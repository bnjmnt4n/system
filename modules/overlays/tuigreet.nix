{ lib, naersk, fetchgit, pam, ... }:

naersk.buildPackage rec {
  name = "tuigreet";
  version = "0.1.1";

  src = fetchgit {
    url = "https://github.com/apognu/tuigreet";
    rev = version;
    sha256 = "lTa6q55tJv+FqnYcpfjxgViWd2/5HfpIk6XoX5uRKms=";
  };

  buildInputs = [
  ];
}
