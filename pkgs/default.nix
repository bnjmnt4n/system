inputs: final: prev: let
  nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system};
in {
  scripts = import ./shared/scripts.nix {
    pkgs = final;
    inherit inputs;
  };
  inherit nixpkgs-stable;

  # Avoid running tests since they take a long time.
  jujutsu = prev.jujutsu.overrideAttrs (old: {
    doCheck = false;
  });

  detect = prev.callPackage ./shared/detect.nix {
    src = inputs.detect;
  };

  telescope-fzf-native = prev.callPackage ./shared/telescope-fzf-native.nix {
    src = inputs.telescope-fzf-native;
  };

  clop = prev.callPackage ./darwin/clop.nix {};
  cleanshot = prev.callPackage ./darwin/cleanshot.nix {};
  # Add access to x86 packages if system is running Apple Silicon.
  pkgs-x86 = prev.lib.mkIf (prev.stdenv.hostPlatform.system == "aarch64-darwin") import inputs.nixpkgs {
    system = "x86_64-darwin";
    config.allowUnfree = true;
  };

  otf2bdf = prev.callPackage ./linux/otf2bdf {};
  ttf-console-font = prev.callPackage ./linux/ttf-console-font.nix {};
  argonone-rpi4 = prev.callPackage ./linux/raspberry-pi-4/argonone-rpi4.nix {
    rpi-gpio = prev.python3Packages.callPackage ./linux/raspberry-pi-4/rpi-gpio.nix {};
    smbus2 = prev.python3.pkgs.callPackage ./linux/raspberry-pi-4/smbus2.nix {};
  };
}
