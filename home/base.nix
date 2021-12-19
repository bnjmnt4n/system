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
    age
    aspell
    aspellDicts.en
    dos2unix
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
    tree
    wget
    xdg-utils

    # Code tools
    comby
    tokei
    tree-grepper

    # Nix tools
    nixpkgs-fmt
    rnix-lsp

    # Archiving
    unzip
    unrar
    xz
    zip

    # NUS
    socprint
  ];
}
