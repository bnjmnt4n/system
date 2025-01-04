{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.cleanshot];

  launchd.agents.cleanshot = {
    enable = true;
    config = {
      ProgramArguments = ["${config.home.homeDirectory}/Applications/Home Manager Apps/${pkgs.cleanshot.sourceRoot}/Contents/MacOS/CleanShot X"];
      KeepAlive = {SuccessfulExit = false;};
      ProcessType = "Interactive";
      StandardOutPath = "${config.xdg.cacheHome}/Cleanshot.log";
      StandardErrorPath = "${config.xdg.cacheHome}/Cleanshot.log";
    };
  };
}
