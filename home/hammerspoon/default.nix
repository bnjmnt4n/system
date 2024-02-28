{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.hammerspoon ];

  launchd.agents.hammerspoon = {
    enable = true;
    config = {
      ProgramArguments = [ "${config.home.homeDirectory}/Applications/Home Manager Apps/${pkgs.hammerspoon.sourceRoot}/Contents/MacOS/Hammerspoon" ];
      KeepAlive = { SuccessfulExit = false; };
      ProcessType = "Interactive";
      StandardOutPath = "${config.xdg.cacheHome}/Hammerspoon.log";
      StandardErrorPath = "${config.xdg.cacheHome}/Hammerspoon.log";
    };
  };

  targets.darwin.defaults."org.hammerspoon.Hammerspoon" = {
    # Check for updates.
    SUEnableAutomaticChecks = false;
  };

  home.file.".hammerspoon/init.lua".source = pkgs.substituteAll {
    src = ./init.lua;
    firefox = "${pkgs.firefox-bin}/Applications/Firefox.app";
    wezterm = "${pkgs.wezterm}/Applications/WezTerm.app";
    spotify = "${pkgs.spotify}/Applications/Spotify.app";
    zed = "${pkgs.zed}/Applications/${pkgs.zed.sourceRoot}";
  };
  home.file.".hammerspoon/utils.lua".source = ./utils.lua;
  home.activation.reloadHammerspoon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.hammerspoon}/bin/hs -c "hs.reload()" || true
    $DRY_RUN_CMD sleep 1
    $DRY_RUN_CMD ${pkgs.hammerspoon}/bin/hs -c "hs.console.clearConsole()" || true
  '';
}
