{ config, lib, pkgs, ... }:

{
  # Version control for dummies.
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Benjamin Tan";
    userEmail = "demoneaux@gmail.com";
    delta = {
      enable = true;
    };
    extraConfig = {
      credential = {
        helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
      };
    };
  };

  programs.gh.enable = true;

  home.packages = [ pkgs.libsecret ];
}
