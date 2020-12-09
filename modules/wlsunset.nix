{ pkgs, ... }:

{
  # Screen colour temperature management.
  services.wlsunset = {
    enable = true;
    latitude = "1.3521";
    longitude = "103.8198";
  };
  systemd.user.services.wlsunset.Service = {
    Restart = "always";
    RestartSec = 3;
  };
}
