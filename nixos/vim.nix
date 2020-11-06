{ pkgs, ... }:

{
  # Simple vim configuration.
  programs.vim = {
    enable = true;
    extraConfig = ''
      " Modify default escape and leader mappings for convenience
      inoremap jk <ESC>
      let mapleader = " "

      " Basic settings
      filetype plugin indent on
      syntax on
      set encoding=utf-8
      set clipboard=unnamedplus
    '';
  };
}
