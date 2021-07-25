{ config, lib, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.telega
    ];
  };

  services.emacs.enable = true;
  # Start after graphical session so we can read/write from Wayland keyboard
  # without having to restart the daemon.
  systemd.user.services.emacs = {
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
  };

  # Include Doom Emacs CLI in PATH.
  home.sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin" ];

  # Doom Emacs configuration files.
  xdg.configFile."doom/init.el".source = ./doom/init.el;
  xdg.configFile."doom/packages.el".source = ./doom/packages.el;
  xdg.configFile."doom/config.el".source = ./doom/config.el;

  home.packages = with pkgs; [
    imagemagick
    ripgrep
    coreutils
    fd
    texlive.combined.scheme-full

    sqlite
    graphviz

    (makeDesktopItem {
      name = "org-protocol";
      exec = "emacsclient %u";
      comment = "Org Protocol";
      desktopName = "org-protocol";
      type = "Application";
      mimeType = "x-scheme-handler/org-protocol";
    })
  ];
}
