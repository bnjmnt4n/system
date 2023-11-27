inputs: system: final: prev:
{
  firefox-darwin = prev.callPackage ./firefox-darwin.nix { };
  hammerspoon = prev.callPackage ./hammerspoon.nix { };
  vlc-darwin = prev.callPackage ./vlc-darwin.nix { };
  zed = prev.callPackage ./zed.nix { };

  canvas-downloader = prev.callPackage ./canvas-downloader.nix {
    src = inputs.canvas-downloader;
    inherit (prev.darwin.apple_sdk.frameworks) Security;
  };
  socprint = prev.callPackage ./socprint.nix {
    src = inputs.socprint;
  };

  telescope-fzf-native = prev.callPackage ./telescope-fzf-native.nix {
    src = inputs.telescope-fzf-native;
  };

  # Add access to x86 packages if system is running Apple Silicon.
  pkgs-x86 = prev.lib.mkIf (prev.stdenv.system == "aarch64-darwin") import inputs.nixpkgs {
    system = "x86_64-darwin";
    config.allowUnfree = true;
  };

  spawn = prev.callPackage ./spawn.nix { };
  freeze-focused = prev.callPackage ./freeze-focused.nix { };
  kill-focused = prev.callPackage ./kill-focused.nix { };
  otf2bdf = prev.callPackage ./otf2bdf { };
  ttf-console-font = prev.callPackage ./ttf-console-font.nix { };

  argonone-rpi4 = prev.callPackage ./raspberry-pi-4/argonone-rpi4.nix {
    rpi-gpio = prev.python3Packages.callPackage ./raspberry-pi-4/rpi-gpio.nix { };
    smbus2 = prev.python3.pkgs.callPackage ./raspberry-pi-4/smbus2.nix { };
  };
}
