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
    comby
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
    tokei
    tree
    wget
    xdg-utils
    tree-grepper

    # Archiving
    unzip
    unrar
    xz
    zip

    # NUS
    socprint
  ];
}
