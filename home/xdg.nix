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
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/mailto" = "firefox.desktop"; # TODO
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
