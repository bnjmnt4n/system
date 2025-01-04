{ pkgs, ... }:

{
  imports = [
    ../../home/shared/base.nix

    ../../home/shared/shell.nix
    ../../home/linux/xdg.nix
    ../../home/shared/git.nix
    ../../home/shared/gpg.nix

    ../../home/shared/bat.nix
    ../../home/shared/tmux.nix

    ../../home/shared/neovim

    ../../home/shared/chromium.nix
    ../../home/shared/firefox
    ../../home/linux/gtk.nix
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
