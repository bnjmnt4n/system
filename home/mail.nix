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
    ofcrse = {
      address = "bnjmnt4n@ofcr.se";
      userName = "bnjmnt4n@ofcr.se";
      flavor = "plain";
      passwordCommand = "secret-tool lookup application ofcrse";
      primary = true;
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        patterns = [ "*" ];
      };
      imap = {
        host = "imap.fastmail.com";
        port = 993;
        tls.enable = true;
      };
      msmtp.enable = true;
      smtp = {
        host = "imap.fastmail.com";
        port = 587;
        tls.useStartTls = true;
      };
      notmuch.enable = true;
      realName = "Benjamin Tan";
    };
  };
}
