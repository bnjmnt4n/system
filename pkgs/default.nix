inputs: final: prev:
{
  spawn = prev.callPackage ./spawn.nix { };
  freeze-focused = prev.callPackage ./freeze-focused.nix { };
  kill-focused = prev.callPackage ./kill-focused.nix { };

  # Temporary fix for https://github.com/NixOS/nixpkgs/issues/206958.
  clisp = prev.clisp.override { readline = prev.readline6; };

  # Fetch from Git until a new version is released.
  youtube-dl = prev.youtube-dl.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "ytdl-org";
      repo = "youtube-dl";
      rev = "195f22f679330549882a8234e7234942893a4902";
      sha256 = "bXxgY8/4LUwhyyC29AbVPnfkDFOzht/th9mboaDx55c=";
    };
    patches = [];
    postInstall = "";
  });

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
