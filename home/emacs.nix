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

  home.packages = with pkgs; [
    imagemagick
    ripgrep
    coreutils
    fd
    clang
    texlive.combined.scheme-full

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
