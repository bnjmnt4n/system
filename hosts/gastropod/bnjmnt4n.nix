{ config, lib, pkgs, ... }:

{
  imports = [
    ../../home/base.nix

    ../../home/shell.nix
    ../../home/xdg.nix
    ../../home/git.nix
    ../../home/gpg.nix

    ../../home/bat.nix
    ../../home/delta.nix
    ../../home/tmux.nix

    ../../home/emacs/default.nix
    ../../home/neovim/default.nix

    ../../home/beets.nix
    ../../home/mail.nix

    ../../home/alacritty.nix
    ../../home/chromium.nix
    ../../home/firefox/default.nix
    ../../home/gtk.nix
    ../../home/mpv.nix
    ../../home/spotify.nix
    ../../home/wayland.nix
  ];

  # TODO: remove?
  home.username = "bnjmnt4n";
  home.homeDirectory = "/home/bnjmnt4n";

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

    # PDF
    zathura

    # Apps
    anki
    # appimage-run
    # discord
    dropbox
    # gimp
    libreoffice
    fluminurs
    # musescore
    # octave
    pandoc
    transmission
    zoom-us
  ];

  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    TERMINAL = "alacritty";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";

    # https://github.com/NixOS/nixpkgs/issues/6878
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  xsession.preferStatusNotifierItems = true;
  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
  services.gnome-keyring.enable = true;
  services.poweralertd.enable = true;
}
