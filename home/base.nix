{ config, lib, pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./beets.nix
    ./delta.nix
    ./emacs.nix
    ./git.nix
    ./gpg.nix
    ./mail.nix
    ./neovim/default.nix
    ./poweralertd.nix
    ./tmux.nix
    ./xdg.nix
  ];

  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  # TODO: shift to flake.nix?
  programs.home-manager.enable = true;
  home.stateVersion = "20.09";

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
    ledger
    pandoc
    ripgrep
    rsync
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
    EDITOR = "nvim";
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
