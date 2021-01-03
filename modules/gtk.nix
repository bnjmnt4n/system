{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = { name = "Numix"; package = pkgs.numix-icon-theme; };
    theme = { name = "Arc-Lighter"; package = pkgs.arc-theme; };
    gtk3.extraConfig = {
      gtk-cursor-theme-size = 16;
    };
  };
}
