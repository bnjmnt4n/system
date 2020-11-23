{ config, lib, pkgs, ... }:

{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  services.mbsync.enable = true;

  # Based on https://beb.ninja/post/email/
  accounts.email.accounts = {
    gmail = {
      address = "demoneaux@gmail.com";
      userName = "demoneaux@gmail.com";
      flavor = "gmail.com";
      passwordCommand = "secret-tool lookup application gmail";
      primary = true;
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        patterns = [ "*" "[Gmail]*" ]; # "[Gmail]/Sent Mail" ];
      };
      msmtp.enable = true;
      notmuch.enable = true;
      realName = "Benjamin Tan";
    };
  };
}
