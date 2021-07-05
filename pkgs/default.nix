final: prev:
{
  fluminurs = prev.callPackage ./fluminurs.nix { };
  otf2bdf = prev.callPackage ./otf2bdf { };
  ttf-console-font = prev.callPackage ./ttf-console-font.nix { };
}
