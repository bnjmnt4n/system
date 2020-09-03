{ pkgs, ... }:

{
  environment.systemPackages =
    ([pkgs.emacs] ++
     (with pkgs; [
       imagemagick
       git
       ripgrep
       coreutils
       fd
       clang

       (makeDesktopItem {
         name = "org-protocol";
         exec = "emacsclient %u";
         comment = "Org Protocol";
         desktopName = "org-protocol";
         type = "Application";
         mimeType = "x-scheme-handler/org-protocol";
       })
     ]));

  services.emacs.enable = true;
}
