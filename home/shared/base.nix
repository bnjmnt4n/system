{pkgs, ...}: {
  imports = [
    ./shell.nix
    ./atuin.nix
    ./bat.nix
    ./dig.nix
    ./git.nix
    ./gpg.nix
    ./jujutsu.nix
    ./neovim
    ./nix.nix
    ./ssh.nix
    ./tmux.nix
  ];

  programs.man.generateCaches = !pkgs.stdenv.hostPlatform.isDarwin;

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
      syntax-theme = "modus_operandi_tinted";
    };
    enableGitIntegration = true;
  };

  programs.difftastic.enable = true;

  home.packages = with pkgs; [
    # System
    age
    aspell
    aspellDicts.en
    btop
    curl
    detect
    dust
    dos2unix
    eza
    fdupes
    file
    htop
    jless
    less
    rsync
    tree
    wget
    xdg-utils

    # Archiving
    zip
    unzip
    unrar-wrapper
    # xz

    # Backup
    restic

    # Video
    ffmpeg
    yt-dlp

    # Benchmarking/Performance
    hyperfine
    samply

    # Database
    duckdb

    # Code
    ast-grep
    codespell
    git-pkgs
    git-sizer
    git-who
    jq
    kondo
    mergiraf
    tokei
    tuicr
    scripts.cloneRepo
    scripts.gitRangeDiffMarkdown

    # Default language servers
    vscode-langservers-extracted
    yaml-language-server

    # GitHub Actions
    pinact
    zizmor

    # Rust
    cargo-sweep

    # Others
    month-table
  ];

  home.sessionVariables = {
    # Difftastic: Allow more errors before switching to textual diff.
    DFT_PARSE_ERROR_LIMIT = 10;
  };
}
