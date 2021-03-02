final: prev:
{
  fluminurs = prev.callPackage ./fluminurs.nix {  };
  greetd = prev.callPackage ./greetd.nix {  };
  tuigreet = prev.callPackage ./tuigreet.nix {  };
  ttf-console-font = prev.callPackage ./ttf-console-font.nix {  };
  otf2bdf = prev.callPackage ./otf2bdf {  };
  qtspim = prev.qt5.callPackage ./qtspim.nix {  };
}
