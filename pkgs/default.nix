inputs: system: final: prev:
{
  canvas-downloader = prev.callPackage ./shared/canvas-downloader.nix {
    src = inputs.canvas-downloader;
    inherit (prev.darwin.apple_sdk.frameworks) Security;
  };
  socprint = prev.callPackage ./shared/socprint.nix {
    src = inputs.socprint;
  };
  telescope-fzf-native = prev.callPackage ./shared/telescope-fzf-native.nix {
    src = inputs.telescope-fzf-native;
  };

  clop = prev.callPackage ./darwin/clop.nix { };
  cleanshot = prev.callPackage ./darwin/cleanshot.nix { };
  dark-notify = prev.callPackage ./darwin/dark-notify.nix {
    src = inputs.dark-notify;
  };
  secretive = prev.callPackage ./darwin/secretive.nix { };
  zed = prev.callPackage ./darwin/zed.nix { };
  # Add access to x86 packages if system is running Apple Silicon.
  pkgs-x86 = prev.lib.mkIf (prev.stdenv.system == "aarch64-darwin") import inputs.nixpkgs {
    system = "x86_64-darwin";
    config.allowUnfree = true;
  };

  otf2bdf = prev.callPackage ./linux/otf2bdf { };
  ttf-console-font = prev.callPackage ./linux/ttf-console-font.nix { };
  argonone-rpi4 = prev.callPackage ./linux/raspberry-pi-4/argonone-rpi4.nix {
    rpi-gpio = prev.python3Packages.callPackage ./linux/raspberry-pi-4/rpi-gpio.nix { };
    smbus2 = prev.python3.pkgs.callPackage ./linux/raspberry-pi-4/smbus2.nix { };
  };
}
