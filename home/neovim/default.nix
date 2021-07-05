{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    extraConfig = ''
      lua require('bnjmnt4n')
    '';
  };

  xdg.configFile."nvim/lua".source = ./lua;


  programs.fish = {
    shellAliases.v = "nvim";
  };
  programs.bash.shellAliases = {
    v = "nvim";
  };
}
