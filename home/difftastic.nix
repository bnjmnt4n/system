{ pkgs, ... }:

{
  programs.git.difftastic = {
    enable = true;
    background = "light";
  };
}
