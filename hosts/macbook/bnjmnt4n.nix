{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ./dock.nix) createDirTile;
in {
  imports = [
    # Mac apps
    ../../home/darwin/karabiner-elements
    ../../home/darwin/rectangle.nix
    ../../home/darwin/cleanshot.nix
    ../../home/darwin/clop.nix
    ../../home/darwin/secretive.nix

    ../../home/shared/base.nix

    ../../home/shared/shell.nix
    ../../home/shared/atuin.nix
    ../../home/shared/bat.nix
    ../../home/shared/firefox.nix
    ../../home/shared/git.nix
    ../../home/shared/gpg.nix
    ../../home/shared/helix.nix
    ../../home/shared/neovim
    ../../home/shared/jujutsu.nix
    ../../home/shared/tmux.nix
    # ../../home/shared/zed-editor.nix

    ../../home/shared/ghostty
  ];

  home.packages = with pkgs; [
    ffmpeg
    jetbrains.idea
    restic
    yt-dlp
  ];

  # Disable login message.
  home.file.".hushlogin".text = "";

  age.identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
  age.secrets.restic-repositories.file = ../../secrets/restic-repositories.age;

  home.sessionVariables = {
    RESTIC_REPOSITORY_PATH = config.age.secrets.restic-repositories.path;
    MANPAGER = "nvim +Man!";
  };

  # Shell aliases.
  programs.fish.shellAliases.setup-restic-env = "${pkgs.coreutils}/bin/cat ${config.age.secrets.restic-repositories.path} | source ${pkgs.scripts.setupResticEnv}/bin/setup-restic-env";

  # Setup Dock.
  home.activation.setupMacosDock = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD defaults write com.apple.dock persistent-others -array ${
      lib.strings.concatStringsSep " " (map createDirTile [
        {
          path = "/Applications/";
          fileType = 1;
          arrangement = 1;
          displayAs = 1;
          showAs = 2;
        }
        {
          path = "${config.home.homeDirectory}/Documents/";
          fileType = 2;
          arrangement = 2;
          displayAs = 0;
          showAs = 1;
        }
        {
          path = "${config.home.homeDirectory}/Downloads/";
          fileType = 2;
          arrangement = 2;
          displayAs = 0;
          showAs = 1;
        }
      ])
    }
    $DRY_RUN_CMD killall Dock
  '';
}
