{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  treeSitterLanguages = [
    "astro"
    "bash"
    "c"
    "cmake"
    "comment"
    "cpp"
    "css"
    "csv"
    "diff"
    "dockerfile"
    "editorconfig"
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
    "http"
    "ini"
    "java"
    "javascript"
    "jsdoc"
    "json"
    "json5"
    "jsonc"
    "latex"
    "ledger"
    "lua"
    "luadoc"
    "make"
    "markdown"
    "markdown_inline"
    "nix"
    "ocaml"
    "proto"
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
    "xml"
    "yaml"
    "zig"
  ];
  # Ensure that the same version of nvim-treesitter is used to get the parsers and queries.
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    pkgs: (map (language: pkgs.${language}) treeSitterLanguages)
  );
  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = nvim-treesitter.dependencies;
  };
  aliases = {
    nvim = "nvim";
    git-diff = "git-jump diff";
    git-status = "nvim -c 'Telescope git_status'";
    grep = "rg --vimgrep -- $argv | nvim -q - -c 'copen'";
  };
in {
  home.activation.lazyNvimSetup = lib.hm.dag.entryAfter ["installPackages" "linkGeneration" "writeBoundary"] ''
    CUSTOM_PATH="${lib.makeBinPath [config.programs.neovim.package pkgs.bash pkgs.coreutils pkgs.git pkgs.nix]}"

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
      PATH=$CUSTOM_PATH $DRY_RUN_CMD git -C $LAZY_DIR fetch --force --filter=blob:none https://github.com/folke/lazy.nvim.git
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
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;

    extraLuaConfig = ''
      vim.g.is_mac = '${
        if pkgs.stdenv.hostPlatform.isDarwin
        then "1"
        else "0"
      }'

      vim.g.lazy_rev = '${inputs.lazy-nvim.rev}'
      vim.g.nvim_treesitter_path = '${nvim-treesitter}'
      vim.g.telescope_fzf_native_path = '${pkgs.telescope-fzf-native}'
      vim.g.node_binary_path = '${pkgs.nodejs}/bin/node'

      require('bnjmnt4n')
    '';
  };

  xdg.configFile."nvim/parser".source = "${treesitter-parsers}/parser";

  xdg.configFile."nvim/after".source = ./after;
  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/filetype.lua".source = ./filetype.lua;

  home.shellAliases.v = aliases.nvim;
  home.shellAliases.vd = aliases.git-diff;
  home.shellAliases.vo = aliases.git-status;
  home.shellAliases.n = aliases.nvim;
  home.shellAliases.nd = aliases.git-diff;
  home.shellAliases.no = aliases.git-status;

  programs.fish.functions.vs = aliases.grep;
  programs.fish.functions.ns = aliases.grep;
}
