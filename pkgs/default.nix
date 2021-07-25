inputs: final: prev:
{
  fluminurs = prev.callPackage ./fluminurs.nix { };
  otf2bdf = prev.callPackage ./otf2bdf { };
  telescope-fzf-native = prev.callPackage ./telescope-fzf-native.nix {
    src = inputs.telescope-fzf-native;
  };
  ttf-console-font = prev.callPackage ./ttf-console-font.nix { };
}
