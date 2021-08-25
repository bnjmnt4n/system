inputs: final: prev:
{
  spawn = prev.callPackage ./spawn.nix { };
  freeze-focused = prev.callPackage ./freeze-focused.nix { };
  kill-focused = prev.callPackage ./kill-focused.nix { };

  fluminurs = prev.callPackage ./fluminurs.nix {
    src = inputs.fluminurs;
  };
  socprint = prev.callPackage ./socprint.nix {
    src = inputs.socprint;
  };
  otf2bdf = prev.callPackage ./otf2bdf { };
  telescope-fzf-native = prev.callPackage ./telescope-fzf-native.nix {
    src = inputs.telescope-fzf-native;
  };
  ttf-console-font = prev.callPackage ./ttf-console-font.nix { };

  argonone-rpi4 = prev.callPackage ./raspberry-pi-4/argonone-rpi4.nix {
    rpi-gpio = prev.python3Packages.callPackage ./raspberry-pi-4/rpi-gpio.nix { };
    smbus2 = prev.python3.pkgs.callPackage ./raspberry-pi-4/smbus2.nix { };
  };
}
