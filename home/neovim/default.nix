{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      lua require('init')
    '';
  };

  xdg.configFile."nvim/lua/init.lua".source = ./init.lua;

  # TODO: currently broken
  home.packages = [
    # Rust GUI
    pkgs.neovide
  ];
}
