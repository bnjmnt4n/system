{ config, lib, pkgs, inputs, ... }:

let
  scripts = import ../../lib/scripts.nix { inherit pkgs inputs; };
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
    hyperfine
    jq
    less
    rsync
    samply
    tree
    wget
    xdg-utils

    # Diff tools
    delta
    difftastic

    # Code tools
    # ast-grep
    codespell
    git-sizer
    # comby
    tokei

    # Nix tools
    nixd
    nixpkgs-fmt
    scripts.nixFlakeInit
    scripts.nixFlakeSync

    # Archiving
    zip
    unzip
    # unrar
    # xz

    # Default language servers
    nodePackages.vscode-langservers-extracted
  ];

  home.sessionVariables = {
    # Difftastic: Allow more errors before switching to textual diff.
    DFT_PARSE_ERROR_LIMIT = 10;
  };
}
