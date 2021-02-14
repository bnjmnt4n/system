{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      " modify default escape and leader mappings for convenience
      inoremap jk <esc>
      let mapleader = " "

      " basic settings
      filetype plugin indent on
      syntax on
      set encoding=utf-8
      set clipboard=unnamedplus
    '';
  };
}
