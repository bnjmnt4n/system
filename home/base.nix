{ config, lib, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./gpg.nix
    ./emacs.nix
    ./mail.nix
    ./neovim.nix
    ./xdg.nix
  ];

  home.file.".config/nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  # TODO: shift to flake.nix?
  programs.home-manager.enable = true;
  home.stateVersion = "20.09";

  home.packages = with pkgs; [
    # System
    aspell
    aspellDicts.en
    bat
    delta
    exa
    fd
    file
    fzf
    gvfs
    htop
    jq
    less
    ledger
    pandoc
    ripgrep
    rsync
    tmux
    tree
    wget
    xdg-utils

    cachix

    # Archiving
    unzip
    unrar
    xz
    zip

    # Media
    ffmpeg
    gifsicle
    imagemagick

    # LaTeX
    texlive.combined.scheme-full

    # Database
    sqlite
    graphviz

    # LumiNUS CLI client
    fluminurs
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -nw -c -a emacs";
  };

  # Switch environments easily.
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    enableNixDirenvIntegration = true;
    stdlib = pkgs.lib.readFile ./.direnvrc;
  };

  # Fast Rust-powered shell prompt.
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  # Fish shell.
  programs.fish = {
    enable = true;
    shellInit = ''
      # Clear greeting.
      set fish_greeting
    '';
  };

  programs.bash.enable = true;

  services.gnome-keyring.enable = true;
}
