{ config, lib, pkgs, inputs, ... }:

let
  customNeovim =
    if pkgs.stdenv.hostPlatform.system == "aarch64-linux"
    then
      pkgs.neovim-nightly.override { lua = pkgs.luajit; }
    else
      pkgs.neovim-nightly;
  treeSitterLanguages = [
    "astro"
    "bash"
    "c"
    "comment"
    "cpp"
    "css"
    "fish"
    "git_config"
    "git_rebase"
    "gitattributes"
    "gitcommit"
    "gitignore"
    "go"
    "gomod"
    "gosum"
    "graphql"
    "haskell"
    "html"
    "ini"
    "java"
    "javascript"
    "jsdoc"
    "json"
    "jsonc"
    "ledger"
    "lua"
    "make"
    "markdown"
    "markdown_inline"
    "nix"
    "ocaml"
    "python"
    "query"
    "regex"
    "ruby"
    "rust"
    "scss"
    "sql"
    "svelte"
    "toml"
    "tsx"
    "typescript"
    "vim"
    "vimdoc"
    "vue"
    "yaml"
    "zig"
  ];
  # Ensure that the same version of nvim-treesitter is used to get the parsers and queries.
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (pkgs: (map (language: pkgs."${language}") treeSitterLanguages));
  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = nvim-treesitter.dependencies;
  };
in
{
  home.activation.lazyNvimSetup = lib.hm.dag.entryAfter [ "installPackages" "linkGeneration" "writeBoundary" ] ''
    CUSTOM_PATH="${lib.makeBinPath [ customNeovim pkgs.bash pkgs.coreutils pkgs.git pkgs.nix ]}"

    LAZY_DIR=$HOME/.local/share/nvim/lazy/lazy.nvim
    if [ ! -d $LAZY_DIR/.git ]; then
      echo "Initializing lazy.nvim repository"
      $DRY_RUN_CMD mkdir -p $LAZY_DIR
      PATH=$CUSTOM_PATH $DRY_RUN_CMD git -C $LAZY_DIR init
    else
      $VERBOSE_ECHO "lazy.nvim repository exists, skipping"
    fi

    if [ $(git -C $LAZY_DIR rev-parse HEAD) != "${inputs.lazy-nvim.rev}" ]; then
      echo "Updating lazy.nvim"
      PATH=$CUSTOM_PATH $DRY_RUN_CMD git -C $LAZY_DIR fetch --no-tags --filter=blob:none https://github.com/folke/lazy.nvim.git
      PATH=$CUSTOM_PATH $DRY_RUN_CMD git -C $LAZY_DIR checkout ${inputs.lazy-nvim.rev}
    else
      $VERBOSE_ECHO "lazy.nvim is up to date, skipping"
    fi

    STATE_DIR=~/.local/state/nix/
    STATE_FILE=$STATE_DIR/lazy-lock-checksum
    LOCK_FILE=~/.config/nvim/lazy-lock.json

    if [ ! -f $LOCK_FILE ]; then
      echo "Copying initial lazy.nvim lockfile"
      $DRY_RUN_CMD cat ${./lazy-lock.json} > $LOCK_FILE
    fi

    if [ ! -d $STATE_DIR ]; then
      mkdir -p $STATE_DIR
    fi

    if [ ! -f $STATE_FILE ]; then
      touch $STATE_FILE
    fi

    HASH=$(PATH=$CUSTOM_PATH nix-hash --flat $LOCK_FILE)
    if [ "$(cat $STATE_FILE)" != "$HASH" ]; then
      echo "Syncing neovim plugins"
      PATH=$CUSTOM_PATH $DRY_RUN_CMD nvim --headless "+Lazy! restore" +qa
      $DRY_RUN_CMD echo $HASH > $STATE_FILE
    else
      $VERBOSE_ECHO "Neovim plugins already up to date, skipping"
    fi
  '';

  programs.neovim = {
    enable = true;
    package = customNeovim;
    withPython3 = false;
    withRuby = false;

    extraLuaConfig = ''
      vim.g.is_mac = '${if pkgs.stdenv.hostPlatform.isDarwin then "1" else "0"}'
      vim.g.slow_device = not vim.g.is_mac

      vim.g.nvim_treesitter_path = '${nvim-treesitter}'
      vim.g.telescope_fzf_native_path = '${pkgs.telescope-fzf-native}'
      vim.g.node_binary_path = '${pkgs.nodejs}/bin/node'

      require('bnjmnt4n')
    '';
  };

  home.packages = lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin)
    [ pkgs.dark-notify ];

  xdg.configFile."nvim/parser".source = "${treesitter-parsers}/parser";
  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/filetype.lua".source = ./filetype.lua;
  xdg.configFile."nvim/luasnippets".source = ./luasnippets;

  # Shell aliases.
  home.shellAliases.v = "nvim";
}
