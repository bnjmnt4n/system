{ config, lib, pkgs, ... }:

{
  imports = [
    ../../home/base.nix

    ../../home/shell.nix
    ../../home/xdg.nix
    ../../home/git.nix
    ../../home/gpg.nix

    ../../home/bat.nix
    ../../home/tmux.nix

    ../../home/neovim

    ../../home/chromium.nix
    ../../home/firefox
    ../../home/gtk.nix
    # ../../home/mpv.nix
    # ../../home/spotify.nix

    ../../home/i3.nix
    ../../home/polybar.nix
  ];

  home.packages = with pkgs; [
    # File manager
    (xfce.thunar.override {
      thunarPlugins = [
        xfce.thunar-volman
        # TODO: seems like the archive plugin does not detect xarchiver as a backend
        xfce.thunar-archive-plugin
      ];
    })
    xarchiver
    android-file-transfer # Simple Android GUI

    # Media
    imv
    ffmpeg
    gifsicle
    imagemagick
    mpv

    # PDF
    zathura

    # Apps
    # anki
    # dropbox
    libreoffice
    # musescore
    # octave
    # pandoc
    # transmission
    # zoom-us
  ];

  home.sessionVariables = {
    # TODO: better terminal?
    TERMINAL = "xfce4-terminal";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  xsession.preferStatusNotifierItems = true;
  # services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
  services.gnome-keyring.enable = true;
}
