{ pkgs, ... }:

{
  home.packages = with pkgs; [
    imagemagick
    ripgrep
    coreutils
    fd
    clang
    # texlive.combined.scheme-full

    (makeDesktopItem {
      name = "org-protocol";
      exec = "emacsclient %u";
      comment = "Org Protocol";
      desktopName = "org-protocol";
      type = "Application";
      mimeType = "x-scheme-handler/org-protocol";
    })
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGccPgtk;
  };
}
