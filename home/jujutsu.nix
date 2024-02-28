{ config, pkgs, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Benjamin Tan";
        email = "benjamin@dev.ofcr.se";
      };
      ui = {
        pager = "less -FRX";
        default-command = "st";
      };
      template-aliases = { };
      revset-aliases = {
        stack = "(trunk()-..@)::";
        parents = "@-";
        ancestors = "::@";
        my-unmerged = "mine() ~ ::trunk()";
        my-unmerged-remote = "mine() ~ ::trunk() & remote_branches()";
        not-pushed = "remote_branches()..";
      };
      signing = {
        sign-all = true;
        backend = "gpg";
        key = "A853F0716C413825";
      };
    };
  };
}
