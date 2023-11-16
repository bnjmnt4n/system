{ config, lib, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    package = pkgs.emptyDirectory;
    extraConfig = ''
      return {
        font = wezterm.font("Iosevka Nerd Font"),
        font_size = 20.0,
        color_scheme = "Modus-Operandi",
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };
}
