{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./browsers/default.nix
    ./gtk.nix
    ./mpv.nix
    ./spotify.nix
    ./wayland.nix
  ];

  home.packages = with pkgs; [
    # System
    # Theoretically not a GUI tool, but only used in GUI environments.
    brightnessctl

    # System bar and trays
    networkmanagerapplet

    # File manager
    xfce.thunar

    # Editors
    vscodium

    # Media
    gimp
    imv
    playerctl # Theoretically not a GUI tool, but only used in GUI environments.
    # vlc

    # PDF
    zathura

    # Apps
    anki
    bitwarden
    bitwarden-cli
    dropbox
    libreoffice
    musescore
    # octave
    pavucontrol
    tdesktop
    webtorrent_desktop

    # Videoconferencing
    zoom-us # hmmm...
    teams
  ];

  home.sessionVariables = {
    TERMINAL = "alacritty";
    EDITOR = "emacsclient -nw -c -a emacs";
    VISUAL = "emacsclient -c -a emacs";
    BROWSER = "firefox";
  };

  # Bluetooth controls.
  services.blueman-applet.enable = true;
}
