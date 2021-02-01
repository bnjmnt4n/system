{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./browsers/default.nix
    ./gtk.nix
    ./java-env.nix
    ./mpv.nix
    ./spotify.nix
    ./wayland.nix
  ];

  home.packages = with pkgs; [
    # System
    # Theoretically not a GUI tool, but only used in GUI environments.
    brightnessctl

    # File manager
    (xfce.thunar.override {
      thunarPlugins = [
        xfce.thunar-volman
        # TODO: seems like the archive plugin does not detect xarchiver as a backend
        xfce.thunar-archive-plugin
      ];
    })
    xarchiver

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
    appimage-run
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
  ];

  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "i695";
    TERMINAL = "alacritty";
    EDITOR = "emacsclient -nw -c -a emacs";
    VISUAL = "emacsclient -c -a emacs";
    BROWSER = "firefox";
  };

  # Wifi/Bluetooth applets.
  xsession.preferStatusNotifierItems = true;
  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
}
