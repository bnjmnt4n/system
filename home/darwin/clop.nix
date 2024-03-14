{ config, pkgs, ... }:

{
  home.packages = [ pkgs.clop ];

  launchd.agents.clop = {
    enable = true;
    config = {
      ProgramArguments = [ "${config.home.homeDirectory}/Applications/Home Manager Apps/${pkgs.clop.sourceRoot}/Contents/MacOS/Clop" ];
      KeepAlive = { SuccessfulExit = false; };
      ProcessType = "Interactive";
      StandardOutPath = "${config.xdg.cacheHome}/Clop.log";
      StandardErrorPath = "${config.xdg.cacheHome}/Clop.log";
    };
  };

  targets.darwin.defaults."com.lowtechguys.Clop" = {
    SUHasLaunchedBefore = true;
    SUAutomaticallyUpdate = false;
    SUEnableAutomaticChecks = false;

    showMenubarIcon = true;
    showFloatingHatIcon = false;
    enableClipboardOptimiser = true;
    enableAutomaticImageOptimisations = true;
    enableAutomaticVideoOptimisations = true;
    enableAutomaticPDFOptimisations = true;
    adaptiveImageSize = true;
    autoCopyToClipboard = true;
    enableDragAndDrop = false;

    imageDirs = [ "${config.home.homeDirectory}/Desktop/Clop" ];
    videoDirs = [ "${config.home.homeDirectory}/Desktop/Clop" ];
    pdfDirs = [ "${config.home.homeDirectory}/Desktop/Clop" ];
  };
}
