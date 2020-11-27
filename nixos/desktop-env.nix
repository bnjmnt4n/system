{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./browsers.nix
    ./wayland.nix
    ./spotify.nix
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
    vscode

    # Media
    gimp
    imv
    mpv
    playerctl # Theoretically not a GUI tool, but only used in GUI environments.
    vlc

    # PDF
    zathura

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
