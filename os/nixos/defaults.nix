{
  config,
  lib,
  pkgs,
  ...
}: {
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = lib.mkDefault "Lat2-Terminus16";
    keyMap = "us";
  };

  location = {
    latitude = 1.3521;
    longitude = 103.8198;
  };

  time.timeZone = "Asia/Singapore";
}
