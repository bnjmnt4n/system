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

  programs.nix-index.enable = true;
  programs.ripgrep = {
    enable = true;
    arguments = [
      # Search case-insensitively if pattern is all lowercase.
      "--smart-case"
    ];
  };

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
    htop
    jq
    less
    rsync
    tree
    wget
    xdg-utils

    # Code tools
    # ast-grep
    # comby
    tokei

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

    # Default language servers
    nodePackages.vscode-langservers-extracted

    # NUS
    socprint
  ];
}
