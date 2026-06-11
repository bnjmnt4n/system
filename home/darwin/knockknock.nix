{pkgs, ...}: {
  home.packages = with pkgs; [
    knockknock
  ];

  targets.darwin.defaults."com.objective-see.KnockKnock" = {
    noUpdateCheck = 1;
    notFirstTime = 1;
  };
}
