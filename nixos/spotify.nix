{ pkgs, ... }:

{
  # Spotify daemon.
  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override {
      withKeyring = true;
      withMpris = true;
    };
    settings = {
      global = {
        username = "demoneaux";
        device_name = "spotifyd";
        use_keyring = "true";
      };
    };
  };

  home.packages = [
    pkgs.spotify-tui
  ];
}
