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
    };
    settings = {
      global = {
        username = "demoneaux";
        device_name = "spotifyd";
        use_keyring = true;
        onevent = "${notificationsScript}";
      };
    };
  };

  xdg.configFile."spotify-tui/config.yml".text = ''
    theme:
      active: Cyan
      analysis_bar_text: Black
      playbar_text: Black
      text: Black
      header: Black
  '';

  home.packages = with pkgs; [
    ncspot
    spotify-tui
  ];
}
