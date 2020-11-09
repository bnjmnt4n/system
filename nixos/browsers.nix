{ pkgs, ... }:

{
  home.packages = with pkgs; [
    chromium
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    # profiles = {
    #   default = {
    #     name = "default";
    #     userChrome = pkgs.lib.readFile ./firefox.userChrome.css;
    #   };
    # };
  };
}
