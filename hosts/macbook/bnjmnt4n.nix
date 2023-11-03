{ config, lib, pkgs, ... }:

let
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
in
{
  imports = [
    ../../home/base.nix

    ../../home/shell.nix
    ../../home/git.nix
    ../../home/gpg.nix

    ../../home/alacritty.nix
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
}
