{ config, lib, pkgs, ... }:

let
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
  quote = str: "'${str}'";
  createAppTile = path:
    quote (
      builtins.replaceStrings [ "\n" ] [ "" ]
        ''
          <dict>
            <key>tile-data</key>
            <dict>
              <key>file-data</key>
              <dict>
                <key>_CFURLString</key>
                <string>file://${toString path}</string>
                <key>_CFURLStringType</key>
                <integer>15</integer>
              </dict>
            </dict>
          </dict>
        ''
    );
  createDirTile = { path, fileType, arrangement, displayAs, showAs }:
    quote (
      builtins.replaceStrings [ "\n" ] [ "" ]
        ''
          <dict>
            <key>tile-data</key>
            <dict>
              <key>file-data</key>
              <dict>
                <key>_CFURLString</key>
                <string>file://${toString path}</string>
                <key>_CFURLStringType</key>
                <integer>15</integer>
              </dict>
              <key>file-type</key>
              <integer>${toString fileType}</integer>
              <key>arrangement</key>
              <integer>${toString arrangement}</integer>
              <key>displayas</key>
              <integer>${toString displayAs}</integer>
              <key>showas</key>
              <integer>${toString showAs}</integer>
            </dict>
            <key>tile-type</key>
            <string>directory-tile</string>
          </dict>
        ''
    );
in
{
  imports = [
    ../../home/karabiner-elements
    ../../home/hammerspoon

    ../../home/base.nix

    ../../home/shell.nix
    ../../home/git.nix
    ../../home/gpg.nix

    ../../home/wezterm.nix
    ../../home/bat.nix
    ../../home/firefox
    ../../home/difftastic.nix # ../../home/delta.nix
    ../../home/tmux.nix

    ../../home/neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = [
    pkgs.canvas-downloader
    pkgs.socprint
  ];

  # Disable login message.
  home.file.".hushlogin".text = "";

  # Setup Dock.
  # TODO: Make it configuration once https://github.com/LnL7/nix-darwin/pull/619 gets merged
  home.activation.setupMacosDock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD defaults write com.apple.dock persistent-apps -array ${
        lib.strings.concatMapStringsSep " " createAppTile [
          "${pkgs.firefox-bin}/Applications/Firefox.app/"
          "${pkgs.wezterm}/Applications/WezTerm.app/"
          "${pkgs.spotify}/Applications/Spotify.app/"
          "/Applications/Google Chrome.app/"
          "/System/Cryptexes/App/System/Applications/Safari.app"
        ]
      }
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
            path = "/Users/${config.home.username}/Downloads/";
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
