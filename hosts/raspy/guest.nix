{ pkgs, ... }:

{
  imports = [
    ../../home/base.nix

    ../../home/gtk.nix
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
    chromium
    firefox
    libreoffice
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
  };

  xsession.preferStatusNotifierItems = true;
  # services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
  services.gnome-keyring.enable = true;
}
