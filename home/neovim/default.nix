{ config, lib, pkgs, inputs, ... }:

let
  customNeovim =
    if pkgs.stdenv.isAarch64
    then
      pkgs.neovim-nightly.override
        {
          lua = pkgs.luajit;
        }
    else
      pkgs.neovim-nightly;
  lazyNvimSetupScript = pkgs.writeScript "lazy-nvim-setup" ''
    #!/bin/sh
    set -eux
    export PATH="${lib.makeBinPath [ customNeovim pkgs.bash pkgs.coreutils pkgs.git ]}"

    LAZY_DIR=$HOME/.local/share/nvim/lazy/lazy.nvim
    if [ ! -d $LAZY_DIR/.git ]; then
      mkdir -p $LAZY_DIR
      git -C $LAZY_DIR init
    fi

    if [ $(git -C $LAZY_DIR rev-parse HEAD) != "${inputs.lazy-nvim.rev}" ]; then
      git -C $LAZY_DIR fetch --filter=blob:none https://github.com/folke/lazy.nvim.git
      git -C $LAZY_DIR checkout ${inputs.lazy-nvim.rev}
    fi
  '';
  treeSitterLanguages = [
    "astro"
    "bash"
    "c"
    "comment"
    "cpp"
    "css"
    "fish"
    "glimmer"
    "go"
    "gomod"
    "graphql"
    "haskell"
    "html"
    "java"
    "javascript"
    "jsdoc"
    "json"
    "ledger"
    "lua"
    "make"
    "nix"
    "ocaml"
    "python"
    "query"
    "regex"
    "ruby"
    "rust"
    "scss"
    "svelte"
    "toml"
    "tsx"
    "typescript"
    "vue"
    "yaml"
    "zig"
  ];
in
{
  home.activation.lazyNvimSetup = lib.hm.dag.entryAfter [ "installPackages" "linkGeneration" ] ''
    ${lazyNvimSetupScript}
  '';

  programs.neovim = {
    enable = true;
    package = customNeovim;
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (pkgs: (map (language: pkgs."${language}") treeSitterLanguages)))
    ];
    withPython3 = false;
    withRuby = false;

    extraConfig = ''
      " Disable default plugins
      let g:loaded_matchit = 1
      let g:loaded_netrw = 1
      let g:loaded_netrwPlugin = 1
      let g:loaded_netrwSettings = 1
      let g:loaded_netrwFileHandlers = 1
      let g:loaded_vimball = 1
      let g:loaded_vimballPlugin = 1

      " Oh god all my devices are slow tbh
      let g:slow_device = 1

      lua require('bnjmnt4n')
    '';
  };

  home.file.".local/share/nvim/lazy/telescope-fzf-native.nvim/build/libfzf.so".source = "${pkgs.telescope-fzf-native}/build/libfzf.so";
  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/ftdetect".source = ./ftdetect;

  # Shell aliases.
  programs.fish.shellAliases.v = "nvim";
  programs.bash.shellAliases.v = "nvim";
}
