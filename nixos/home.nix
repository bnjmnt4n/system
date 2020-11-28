{ config, lib, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./emacs.nix
    ./vim.nix
    ./mail.nix
    ./desktop-env.nix
  ];

  home.file.".config/nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  programs.home-manager.enable = true;
  home.stateVersion = "20.09";

  home.username = "bnjmnt4n";
  home.homeDirectory = "/home/bnjmnt4n";

  home.packages = with pkgs; [
    # System
    aspell
    aspellDicts.en
    bat
    fd
    file
    fzf
    gvfs
    jq
    less
    ledger
    libnotify
    libsecret
    pass
    pandoc
    ripgrep
    rsync
    tree
    wget
    xdg_utils

    cachix

    # Archiving
    unzip
    unrar
    xz
    zip

    # Media
    ffmpeg-full
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

  # Convenient shell integration with nix-shell.
  services.lorri.enable = true;

  # Switch environments easily.
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    # TODO: enableNixDirenvIntegration?
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
      # TODO: use home-manager's modules for some of this.
      # Clear greeting.
      set fish_greeting
    '';
  };
}
