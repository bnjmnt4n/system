{ config, lib, pkgs, inputs, ... }:

let
  scripts = import ../lib/scripts.nix { inherit pkgs inputs; };
in
{
  imports = [
    ./dig.nix
    ./ssh.nix
  ];

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
    eza
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
    # ast-grep
    # comby
    tokei
    # TODO: there are no aarch64 binaries for tree-grepper
    # (lib.mkIf (!pkgs.hostPlatform.stdenv.isAarch64) tree-grepper)

    # Nix tools
    nixpkgs-fmt
    rnix-lsp
    scripts.nixFlakeInit
    scripts.nixFlakeSync

    # Archiving
    zip
    unzip
    # unrar
    # xz

    # NUS
    socprint
  ];
}
