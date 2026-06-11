{pkgs, ...}: {
  home.packages = with pkgs; [
    vlc-bin
  ];

  targets.darwin.defaults."org.videolan.vlc" = {
    SUEnableAutomaticChecks = 0;
    SUHasLaunchedBefore = 1;
  };
}
