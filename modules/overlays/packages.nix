final: prev:
rec {
  fluminurs = prev.callPackage ./fluminurs.nix {  };
  greetd = prev.callPackage ./greetd.nix {  };
  tuigreet = prev.callPackage ./tuigreet.nix {  };
}
