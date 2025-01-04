# https://github.com/nix-community/nur-combined/blob/master/repos/drewrisinger/pkgs/raspberrypi/rpi-gpio/default.nix
{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "RPi.GPIO";
  version = "0.7.1a4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IfQ3jYFSWXmtO71g6I/D2frBh5vLFxUeHGZfMmWPk2I=";
  };

  postPatch = ''
    substituteInPlace source/cpuinfo.c --replace "sscanf(buffer, \"Revision	: %s\", revision);" "strcpy(revision, \"d03114\");"
  '';

  # Tests require custom circuit hooked up
  doCheck = false;
  # pythonImportsCheck = [ "RPi.GPIO" ];

  meta = with lib; {
    description = "A module to control Raspberry Pi GPIO channels";
    homepage = "http://sourceforge.net/p/raspberry-gpio-python/wiki/Home/";
    license = licenses.mit;
    platforms = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" ];
    isRpiPkg = true;
  };
}
