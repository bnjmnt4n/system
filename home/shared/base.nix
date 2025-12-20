{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./dig.nix
    ./ssh.nix
  ];

  targets.darwin = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    linkApps.enable = false;
    copyApps.enable = true;
  };

  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  programs.nix-index.enable = true;
  programs.ripgrep = {
    enable = true;
    arguments = [
      # Search case-insensitively if pattern is all lowercase.
      "--smart-case"
    ];
  };
  programs.fd = {
    enable = true;
    ignores = [".jj/" ".DS_Store"];
  };
  programs.fzf.enable = true;
  programs.delta = {
    enable = true;
    options = {
      syntax-theme = "GitHub";
    };
    enableGitIntegration = true;
  };

  home.packages = with pkgs; [
    # System
    age
    aspell
    aspellDicts.en
    curl
    detect
    dos2unix
    eza
    fdupes
    file
    htop
    hyperfine
    jq
    less
    rsync
    samply
    tree
    wget
    xdg-utils

    # Diff/merge tools
    difftastic
    mergiraf

    # Code tools
    ast-grep
    codespell
    git-sizer
    git-who
    gh-pr-versions
    # comby
    tokei
    scripts.cloneRepo

    # Nix tools
    nixd
    alejandra
    scripts.nixFlakeInit
    scripts.nixFlakeSync

    # Archiving
    zip
    unzip
    unrar-wrapper
    # xz

    # Default language servers
    nodePackages.vscode-langservers-extracted
    yaml-language-server
  ];

  home.sessionVariables = {
    # Difftastic: Allow more errors before switching to textual diff.
    DFT_PARSE_ERROR_LIMIT = 10;
  };
}
