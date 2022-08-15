{ config, lib, pkgs, inputs, ... }:

let
  customNeovim =
    if pkgs.stdenv.isAarch64
    then
      pkgs.neovim-nightly.override
        {
          lua = pkgs.luajit;
        }
    else pkgs.neovim-nightly;
  packerNvimSetupScript = pkgs.writeScript "packer-nvim-setup" ''
    #!/bin/sh
    set -eux
    export PATH="${lib.makeBinPath [ customNeovim pkgs.bash pkgs.coreutils pkgs.git ]}"

    PACKER_DIR=$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
    if [ ! -d $PACKER_DIR/.git ]; then
      mkdir -p $PACKER_DIR
      git -C $PACKER_DIR init
    fi

    if [ $(git -C $PACKER_DIR rev-parse HEAD) != "${inputs.packer-nvim.rev}" ]; then
      git -C $PACKER_DIR fetch https://github.com/wbthomason/packer.nvim.git
      git -C $PACKER_DIR checkout ${inputs.packer-nvim.rev}
    fi

    # TODO
    # nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSnapshotRollback default'
  '';
  treeSitterLanguages = [
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
  home.activation.packerNvimSetup = lib.hm.dag.entryAfter [ "installPackages" "linkGeneration" ] ''
    ${packerNvimSetupScript}
  '';

  programs.neovim = {
    enable = true;
    package = customNeovim;

    extraConfig = ''
      " Disable default plugins
      let g:loaded_matchit = 1
      let g:loaded_netrw = 1
      let g:loaded_netrwPlugin = 1
      let g:loaded_netrwSettings = 1
      let g:loaded_netrwFileHandlers = 1
      let g:loaded_vimball = 1
      let g:loaded_vimballPlugin = 1

      let g:slow_device = ${if pkgs.stdenv.isAarch64 then "1" else "0"}

      lua require('bnjmnt4n')
    '';
  };

  xdg.dataFile."nvim/site/pack/packer/opt/telescope-fzf-native.nvim/build/libfzf.so".source = "${pkgs.telescope-fzf-native}/build/libfzf.so";

  xdg.configFile = {
    "nvim/lua" = {
      source = ./lua;
      onChange = ''
        # TODO
        # ${customNeovim}/bin/nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSnapshotRollback default'
        ${customNeovim}/bin/nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
      '';
    };
    "nvim/plugin/packer_snapshots/default".source = ./packer-snapshot.json;
  } // (
    builtins.listToAttrs (map (language: {
      name = "nvim/parser/${language}.so";
      value = {
        source = "${pkgs.tree-sitter.builtGrammars."tree-sitter-${language}"}/parser";
      };
    }) treeSitterLanguages)
  );

  # Shell aliases.
  programs.fish.shellAliases.v = "nvim";
  programs.bash.shellAliases.v = "nvim";
}
