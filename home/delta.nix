{ pkgs, ... }:

{
  programs.git.delta = {
    enable = true;
    options = {
      syntax-theme = "GitHub";
    };
  };
}
