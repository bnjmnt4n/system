{ config, lib, pkgs, ... }:

let
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
in
{
  imports = [
    ../../home/karabiner-elements

    ../../home/base.nix

    ../../home/shell.nix
    ../../home/git.nix
    ../../home/gpg.nix

    ../../home/wezterm.nix
    ../../home/bat.nix
    ../../home/firefox
    # ../../home/difftastic.nix # ../../home/delta.nix
    ../../home/tmux.nix

    ../../home/neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = [
    pkgs.canvas-downloader
    pkgs.socprint
  ];

  # Disable login message.
  home.file.".hushlogin".text = "";
}
