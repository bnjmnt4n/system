{
  lib,
  pkgs,
  ...
}: let
  themes = [
    "modus_operandi"
    "modus_operandi_deuteranopia"
    "modus_operandi_tinted"
    "modus_operandi_tritanopia"
    "modus_vivendi"
    "modus_vivendi_deuteranopia"
    "modus_vivendi_tinted"
    "modus_vivendi_tritanopia"
  ];
in {
  programs.bat = {
    enable = true;
    config.theme-light = "modus_operandi_tinted";
    config.theme-dark = "modus_vivendi_tinted";
    themes = lib.attrsets.genAttrs themes (name: {
      src = pkgs.modus-themes;
      file = "extras/bat/${name}.tmTheme";
    });
  };
}
