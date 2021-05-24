{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    font = {
      name = "Source Sans Pro";
      size = 12;
    };
    theme = {
      name = "Arc-Lighter";
      package = pkgs.arc-theme;
    };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "capitaine-cursors";
      gtk-cursor-theme-size = 24;
    };
  };
}
