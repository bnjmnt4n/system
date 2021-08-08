{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package =
      if pkgs.stdenv.isAarch64 then
        pkgs.neovim-nightly.override
          {
            lua = pkgs.luajit;
          } else pkgs.neovim-nightly;
    extraConfig = ''
      " Disable default plugins
      let g:loaded_matchit = 1
      let g:loaded_netrw = 1
      let g:loaded_netrwPlugin = 1
      let g:loaded_netrwSettings = 1
      let g:loaded_netrwFileHandlers = 1
      let g:loaded_vimball = 1
      let g:loaded_vimballPlugin = 1

      lua require('bnjmnt4n')
    '';
  };

  xdg.configFile."nvim/lua".source = ./lua;

  xdg.dataFile."nvim/site/pack/packer/start/telescope-fzf-native.nvim/build/libfzf.so".source = "${pkgs.telescope-fzf-native}/build/libfzf.so";

  xdg.configFile."nvim/parser/bash.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-bash}/parser";
  xdg.configFile."nvim/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
  # xdg.configFile."nvim/parser/comment.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-comment}/parser";
  xdg.configFile."nvim/parser/cpp.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-cpp}/parser";
  xdg.configFile."nvim/parser/css.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-css}/parser";
  # xdg.configFile."nvim/parser/fish.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-fish}/parser";
  # xdg.configFile."nvim/parser/glimmer.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-glimmer}/parser";
  xdg.configFile."nvim/parser/go.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-go}/parser";
  # xdg.configFile."nvim/parser/graphql.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-graphql}/parser";
  xdg.configFile."nvim/parser/haskell.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-haskell}/parser";
  xdg.configFile."nvim/parser/html.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-html}/parser";
  xdg.configFile."nvim/parser/javascript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-javascript}/parser";
  xdg.configFile."nvim/parser/jsdoc.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-jsdoc}/parser";
  xdg.configFile."nvim/parser/json.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-json}/parser";
  # xdg.configFile."nvim/parser/jsonc.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-jsonc}/parser";
  # xdg.configFile."nvim/parser/ledger.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-ledger}/parser";
  xdg.configFile."nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  xdg.configFile."nvim/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
  xdg.configFile."nvim/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
  # xdg.configFile."nvim/parser/query.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-query}/parser";
  xdg.configFile."nvim/parser/regex.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-regex}/parser";
  xdg.configFile."nvim/parser/ruby.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-ruby}/parser";
  xdg.configFile."nvim/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
  # xdg.configFile."nvim/parser/scss.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-scss}/parser";
  xdg.configFile."nvim/parser/svelte.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-svelte}/parser";
  xdg.configFile."nvim/parser/toml.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-toml}/parser";
  xdg.configFile."nvim/parser/tsx.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-tsx}/parser";
  xdg.configFile."nvim/parser/typescript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-typescript}/parser";
  # xdg.configFile."nvim/parser/vue.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-vue}/parser";
  xdg.configFile."nvim/parser/yaml.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-yaml}/parser";
  xdg.configFile."nvim/parser/zig.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-zig}/parser";

  # Shell aliases.
  programs.fish.shellAliases.v = "nvim";
  programs.bash.shellAliases.v = "nvim";
}
