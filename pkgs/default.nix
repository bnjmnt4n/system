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

  # Karabiner Elements 15.0 is not supported yet in nix-darwin.
  # https://github.com/LnL7/nix-darwin/issues/1041
  karabiner-elements = prev.karabiner-elements.overrideAttrs (old: {
    version = "14.13.0";
    src = prev.fetchurl {
      inherit (old.src) url;
      hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
    };
    dontFixup = true;
  });

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
}
