{ lib, callPackage, naersk, fetchgit, pam, ... }:

naersk.buildPackage rec {
  name = "greetd";
  version = "0.7.0";

  src = fetchgit {
    url = "https://git.sr.ht/~kennylevinsen/greetd";
    rev = version;
    sha256 = "b+S3fuJ8gjnSQzLHl3Bs9iO/Un2ynggAplz01GjJvFI=";
  };

  buildInputs = [
    pam
  ];

  passthru = {
    tuigreet = callPackage ./tuigreet.nix {};
  };
}
