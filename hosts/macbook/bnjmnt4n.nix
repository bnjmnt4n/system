{ config, lib, pkgs, ... }:

let
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
  inherit (import ./dock.nix) createAppTile createDirTile;
in
{
  imports = [
    # Mac apps
    ../../home/darwin/karabiner-elements
    ../../home/darwin/rectangle.nix
    ../../home/darwin/cleanshot.nix
    ../../home/darwin/clop.nix
    ../../home/darwin/secretive.nix

    ../../home/shared/base.nix

    ../../home/shared/shell.nix
    ../../home/shared/bat.nix
    ../../home/shared/git.nix
    ../../home/shared/jujutsu.nix
    ../../home/shared/gpg.nix
    ../../home/shared/tmux.nix
    ../../home/shared/neovim

    ../../home/shared/wezterm.nix
    ../../home/shared/firefox
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = [
    pkgs.canvas-downloader
    pkgs.gg
    pkgs.restic
    pkgs.socprint
    pkgs.zoom-us
    pkgs.zed
  ];

  # Disable login message.
  home.file.".hushlogin".text = "";

  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
  age.secrets.restic-repositories.file = ../../secrets/restic-repositories.age;

  home.sessionVariables = {
    RESTIC_REPOSITORY_PATH = config.age.secrets.restic-repositories.path;
  };

  # Shell aliases.
  programs.fish.shellAliases.gg = "gg &; disown";
  programs.fish.shellAliases.setup-restic-env =
    "${pkgs.coreutils}/bin/cat ${config.age.secrets.restic-repositories.path} | source ${scripts.setupResticEnvNew}";
  home.shellAliases.tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";

  # Setup Dock.
  home.activation.setupMacosDock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
