{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    handy
  ];

  launchd.agents.handy = {
    enable = true;
    config = {
      ProgramArguments = ["${config.home.homeDirectory}/Applications/Home Manager Apps/Handy.app/Contents/MacOS/handy"];
      KeepAlive = {SuccessfulExit = false;};
      ProcessType = "Interactive";
      StandardOutPath = "${config.xdg.cacheHome}/Handy.log";
      StandardErrorPath = "${config.xdg.cacheHome}/Handy.log";
    };
  };
}
