# Copied from https://github.com/thefloweringash/kevin-nix/blob/36eecdcba397c15830b8b09733e7e5a0f2cfe619/packages/otf2bdf/default.nix

{ stdenv, fetchFromGitHub, freetype }:

stdenv.mkDerivation rec {
  name = "otf2bdf-${version}";
  version = "3.1";

  buildInputs = [ freetype ];

  patches = [
    ./0001-Remove-deprecated-MKINSTALLDIRS.patch
    ./0002-Fix-generate_font-return-value.patch
  ];

  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "otf2bdf";
    rev = "cc7f1b5a1220b3a3ffe356e056e6627c64bdf122";
    sha256 = "1q4k75wmxbdbby542glsckyycghlf1sgp9gl0qf1d1hagjp5kbqw";
  };
}
