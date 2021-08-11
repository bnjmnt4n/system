# https://github.com/nix-community/nur-combined/blob/master/repos/drewrisinger/pkgs/raspberrypi/argonone-rpi4/default.nix#L56
{ stdenv
, lib
, fetchFromGitHub
, python3
, libffi
, lm_sensors
, rpi-gpio
, smbus2
  # , wrapPythonProgramsHook
}:

stdenv.mkDerivation {
  # Argon One Package: Fan & Power Button Control
  pname = "argonone-rpi4";
  version = "unstable-2020-09-14";

  src = fetchFromGitHub {
    owner = "elrondo46";
    repo = "argonone";
    rev = "a8c9a564083c5dfb7dc22e72133cc49a6ed083bf";
    sha256 = "sha256-aBwPFMb1jmeBF3qFUfWreYMTuFCZv8+wfQWnK7hai2g=";
  };

  nativeBuildInputs = [ python3.pkgs.wrapPython ];

  buildInputs = [ libffi lm_sensors ];

  propagatedBuildInputs = [ (python3.withPackages (ps: [ rpi-gpio smbus2 ])) ];

  postPatch = ''
    substituteInPlace argononed.py --replace "import smbus" "import smbus2 as smbus"
    substituteInPlace argononed-poweroff.py --replace "import smbus" "import smbus2 as smbus"
  '';

  installPhase = ''
    echo "Copying ArgonOne files to Out Dir"
    mkdir -p $out/bin $out/lib/systemd/system $out/etc $out/opt/argonone
    cp argonone-config $out/bin
    cp *.py $out/opt/argonone
    cp argononed.conf $out/etc/
    cp argononed.service $out/lib/systemd/system/
  '';

  # Only check if building on RaspberryPi, rpi-gpio fails otherwise.
  doInstallCheck = rpi-gpio.doCheck;
  installCheckPhase = ''
    $out/opt/argonone/argononed.py
  '';

  postFixup = ''
    wrapPythonPrograms
    wrapPythonProgramsIn $out/opt/argonone/
  '';

  meta = with lib; {
    description = "Argon One Service and Control Scripts for Raspberry Pi 4";
    homepage = "https://github.com/Elrondo46/argonone";
    platforms = [ "aarch64-linux" ]; # Raspberry Pi 4
    isRpiPkg = true;
  };
}
