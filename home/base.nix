{ config, lib, pkgs, ... }:

{
  # TODO: shift to flake.nix?
  programs.home-manager.enable = true;
  home.stateVersion = "20.09";

  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  home.packages = with pkgs; [
    # System
    aspell
    aspellDicts.en
    exa
    fd
    file
    fzf
    gvfs
    htop
    jq
    less
    ripgrep
    rsync
    tokei
    tree
    wget
    xdg-utils

    # Archiving
    unzip
    unrar
    xz
    zip
  ];
}
