{ pkgs, ... }:

let
  # https://gist.github.com/ohhskar/efe71e82337ed54b9aa704d3df28d2ae.
  notificationsScript = pkgs.writeShellScript "notifications.sh" ''
    if [ "$PLAYER_EVENT" = "start" ] || [ "$PLAYER_EVENT" = "change" ];
    then
      track=$(${pkgs.playerctl}/bin/playerctl --player=spotifyd metadata title)
      artist_album=$(${pkgs.playerctl}/bin/playerctl --player=spotifyd metadata --format "{{ artist }}
{{ album }}")

      ${pkgs.libnotify}/bin/notify-send -u low "$track" "$artist_album"
    fi
  '';
in
{
  # Spotify daemon.
  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override {
      withKeyring = true;
      withMpris = true;
      withALSA = false;
      withPulseAudio = true;
    };
    settings = {
      global = {
        username = "demoneaux";
        device_name = "spotifyd";
        backend = "pulseaudio";
        use_keyring = true;
        onevent = "${notificationsScript}";
      };
    };
  };

  home.packages = [
    pkgs.spotify-tui
  ];
}
