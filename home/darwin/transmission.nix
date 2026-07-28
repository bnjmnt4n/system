{pkgs, ...}: {
  home.packages = with pkgs; [
    transmission_4-mac
  ];

  targets.darwin.defaults."org.m0k.transmission" = {
    SUEnableAutomaticChecks = false;
    SUHasLaunchedBefore = true;
    WarningLegal = false;
    AutoSize = true;
    DownloadLocationConstant = true;
  };
}
