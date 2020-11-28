{ pkgs, ... }:

{
  # Screen colour temperature management.
  services.gammastep = {
    enable = true;
    latitude = "1.3521";
    longitude = "103.8198";
  };
}
