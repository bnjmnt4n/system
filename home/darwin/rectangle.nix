{ config, pkgs, ... }:

{
  home.packages = [ pkgs.rectangle ];

  launchd.agents.rectangle = {
    enable = true;
    config = {
      ProgramArguments = [ "${config.home.homeDirectory}/Applications/Home Manager Apps/Rectangle.app/Contents/MacOS/Rectangle" ];
      KeepAlive = { SuccessfulExit = false; };
      ProcessType = "Interactive";
      StandardOutPath = "${config.xdg.cacheHome}/Rectangle.log";
      StandardErrorPath = "${config.xdg.cacheHome}/Rectangle.log";
    };
  };

  targets.darwin.defaults."com.knollsoft.Rectangle" = {
    SUHasLaunchedBefore = true;
    # Don't check for updates automatically
    SUEnableAutomaticChecks = false;
    # Don't launch on login
    launchOnLogin = false;
    # Move window to adjacent display for repeated left/right actions
    subsequentExecutionMode = 1;
    # Disable window restore when moving windows
    unsnapRestore = 2;
    # Enable todo mode
    todo = 1;
  };
}
