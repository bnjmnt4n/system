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
    ../../home/darwin/aldente.nix
    ../../home/darwin/cleanshot.nix
    ../../home/darwin/clop.nix
    ../../home/darwin/karabiner-elements
    ../../home/darwin/knockknock.nix
    ../../home/darwin/rectangle.nix
    ../../home/darwin/secretive.nix
    ../../home/darwin/transmission.nix
    ../../home/darwin/tuna-launcher.nix
    ../../home/darwin/vlc.nix

    ../../home/shared/firefox.nix
    ../../home/shared/ghostty.nix
    ../../home/shared/helix.nix
    # ../../home/shared/zed-editor.nix

    ../../home/shared/base.nix
  ];

  # Mac apps
  home.packages = with pkgs; [
    caffeine
    imageoptim
    jetbrains.idea
    monodraw
    net-news-wire
  ];

  # Disable login message.
  home.file.".hushlogin".text = "";

  age.identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
  age.secrets.restic-repositories.file = ../../secrets/restic-repositories.age;

  programs.neovim.defaultEditor = true;
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
  };

  # Shell aliases.
  programs.fish.shellAliases.setup-restic-env = "${pkgs.coreutils}/bin/cat ${config.age.secrets.restic-repositories.path} | source ${pkgs.scripts.setupResticEnv}/bin/setup-restic-env";

  # Setup Dock.
  home.activation.setupMacosDock = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run /usr/bin/defaults write com.apple.dock persistent-others -array ${
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
          arrangement = 3; # date-modified
          displayAs = 0;
          showAs = 1;
        }
        {
          path = "${config.home.homeDirectory}/Downloads/";
          fileType = 2;
          arrangement = 3; # date-modified
          displayAs = 0;
          showAs = 1;
        }
      ])
    }
    run /usr/bin/killall Dock
  '';
}
