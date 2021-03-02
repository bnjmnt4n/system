{ config, pkgs, ... }:

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
