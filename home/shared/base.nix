{pkgs, ...}: {
  imports = [
    ./dig.nix
    ./ssh.nix
  ];

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

  home.packages = with pkgs; [
    # System
    age
    aspell
    aspellDicts.en
    curl
    detect
    dos2unix
    eza
    fd
    fdupes
    file
    fzf
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
    delta
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
