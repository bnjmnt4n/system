{ config, lib, pkgs, ... }:

{
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "thunar.desktop";
        "text/html" = "firefox.desktop";
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "application/zip" = "xarchiver.desktop";
        "text/" = "emacsclient.desktop";
        "image/" = "imv.desktop";
        "video/" = "mpv.desktop";
        "audio/" = "mpv.desktop";
      };
    };
  };
}
