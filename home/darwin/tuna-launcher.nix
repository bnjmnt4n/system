{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    tuna-launcher
  ];

  launchd.agents.tuna = {
    enable = true;
    config = {
      ProgramArguments = ["${config.home.homeDirectory}/Applications/Home Manager Apps/Tuna.app/Contents/MacOS/Tuna"];
      KeepAlive = {SuccessfulExit = false;};
      ProcessType = "Interactive";
      StandardOutPath = "${config.xdg.cacheHome}/Tuna.log";
      StandardErrorPath = "${config.xdg.cacheHome}/Tuna.log";
    };
  };

  targets.darwin.defaults."com.maxgoedjen.Secretive.Host" = {
    defaultsHasRunSetup = true;
  };
}
