{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    aldente
  ];

  launchd.agents.aldente = {
    enable = true;
    config = {
      ProgramArguments = ["${config.home.homeDirectory}/Applications/Home Manager Apps/${pkgs.aldente.sourceRoot}/Contents/MacOS/AlDente"];
      KeepAlive = {SuccessfulExit = false;};
      ProcessType = "Interactive";
      StandardOutPath = "${config.xdg.cacheHome}/AlDente.log";
      StandardErrorPath = "${config.xdg.cacheHome}/AlDente.log";
    };
  };

  targets.darwin.defaults."com.apphousekitchen.aldente-pro" = {
    SUHasLaunchedBefore = true;
    SUAutomaticallyUpdate = false;
    SUEnableAutomaticChecks = false;

    chargeVal = 78;
    checkForUpdates = 0;
    exitInhibitCharge = true;
    heatProtectMode = true;
    # Menu bar settings
    menuBarIconStyle = 0;
    showPercentage = false;
    # Popover settings
    showPercentagePopover = true;
  };
}
