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
        diff.tool = "delta";
        diff-editor = ":builtin";
      };
      template-aliases = {
        "format_timestamp(timestamp)" = "timestamp.ago()";
      };
      revsets.log = "stack";
      revset-aliases = {
        overview = "@ | ancestors(immutable_heads().., 2) | trunk()";
        stack = "(trunk()-..@) | @::";
        my-unmerged = "mine() ~ ::trunk()";
        my-unmerged-remote = "mine() ~ ::trunk() & remote_branches()";
        not-pushed = "remote_branches()..";
      };
      aliases = {
        l = [ "log" ];
        lp = [ "log" "-r" "@-" ];
        la = [ "log" "-r" "::@" ];
        lo = [ "log" "-r" "overview" ];
        d = [ "diff" ];
        s = [ "show" ];
        sp = [ "show" "@-" ];
        g = [ "git" ];
      };
      merge-tools = {
        difft = {
          diff-args = [ "--color=always" "$left" "$right" ];
        };
        delta = {
          diff-args = [ "--color-only" "$left" "$right" ];
        };
      };
      signing = {
        sign-all = true;
        backend = "gpg";
        key = "A853F0716C413825";
      };
    };
  };
}
