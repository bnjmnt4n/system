{ config, lib, pkgs, ... }:

{
  imports = [
    ./browsers.nix
    ./emacs.nix
    ./wayland.nix
  ];

  home.file.".config/nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  programs.home-manager.enable = true;
  home.stateVersion = "20.09";

  home.username = "bnjmnt4n";
  home.homeDirectory = "/home/bnjmnt4n";

  home.packages = with pkgs; [
    # Terminal emulator
    alacritty

    # System
    aspell
    aspellDicts.en
    brightnessctl
    fd
    file
    fzf
    gitAndTools.gitFull
    gitAndTools.gh
    gvfs
    jq
    less
    ledger
    libsecret
    pass
    pandoc
    ripgrep
    rofi
    rsync
    tree
    wget
    xdg_utils

    # System bar and trays
    networkmanagerapplet

    # Archiving
    unzip
    unrar
    xz
    zip

    # File manager
    xfce.thunar

    # Editors
    vscode
    vim

    # Media
    gimp
    # ffmpeg-full
    gifsicle
    imagemagick
    mpv
    playerctl
    spotify
    vlc

    # PDF
    ghostscript
    zathura

    # Database
    sqlite
    graphviz

    # Apps
    anki
    bitwarden
    bitwarden-cli
    dropbox
    libreoffice
    musescore
    pavucontrol
    tdesktop
    webtorrent_desktop

    # Videoconferencing
    zoom-us # hmmm...
    teams

    # LumiNUS CLI client
    fluminurs
  ];

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
