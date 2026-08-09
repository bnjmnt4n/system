inputs: final: prev: {
  scripts = import ./scripts.nix {
    pkgs = final;
    inherit inputs;
  };

  modus-themes = inputs.modus-themes;

  # Avoid running tests since they take a long time.
  jujutsu = prev.jujutsu.overrideAttrs (_: {
    doCheck = false;
  });
  mergiraf = prev.mergiraf.overrideAttrs (_: {
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

  telescope-fzf-native = prev.callPackage ./telescope-fzf-native.nix {
    src = inputs.telescope-fzf-native;
  };

  month-table = prev.callPackage ./month-table {};

  clop = prev.callPackage ./clop.nix {};
  cleanshot = prev.callPackage ./cleanshot.nix {};
  imageoptim = prev.callPackage ./imageoptim.nix {};
  knockknock = prev.callPackage ./knockknock.nix {};
}
