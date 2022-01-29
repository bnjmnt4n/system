{ config, lib, pkgs, inputs, ... }:

let
  scripts = import ../lib/scripts.nix { inherit pkgs inputs; };
in
{
  imports = [
    ./dig.nix
  ];

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
    curl
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
    # TODO: there are no aarch64 binaries for tree-grepper
    (lib.mkIf (!pkgs.stdenv.isAarch64) tree-grepper)

    # Nix tools
    nixpkgs-fmt
    rnix-lsp
    scripts.nixFlakeInit
    scripts.nixFlakeSync

    # Archiving
    unzip
    unrar
    xz
    zip

    # NUS
    socprint
  ];
}
