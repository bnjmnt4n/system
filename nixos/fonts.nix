{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      ia-writer-duospace
      inter
      iosevka
      jetbrains-mono
      libre-baskerville
      nerdfonts
      # TODO: overpass doesn't seem to be working.
      overpass
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
      monospace = [ "Source Code Pro" ];
      sansSerif = [ "Source Sans Pro" ];
      serif = [ "Source Serif Pro" ];
      };
    };
  };
}
