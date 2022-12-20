{ pkgs }:

let
  wob = (import ./scripts.nix { inherit pkgs; }).wob;
in
rec {
  terminal = "${pkgs.alacritty}/bin/alacritty";
  browser = "${pkgs.firefox}/bin/firefox";
  browser_alt = "${pkgs.chromium}/bin/chromium";
  emacs = "${pkgs.emacsPgtk}/bin/emacsclient -c -a emacs";
  editor = emacs;
  explorer = "${pkgs.xfce.thunar}/bin/thunar";
  telegram = "${emacs} -e '(=telegram)'";

  # Launcher command.
  launcher = "${pkgs.wofi}/bin/wofi --show drun 'Applications'";

  # Screen brightness.
  wob_show_brightness = "${wob} $(${pkgs.light}/bin/light -G | cut -d'.' -f1)";
  brightness_up = "${pkgs.brightnessctl}/bin/brightnessctl set 10%+ && ${wob_show_brightness}";
  brightness_down = "${pkgs.brightnessctl}/bin/brightnessctl set 10%- && ${wob_show_brightness}";
  brightness_up_small = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+ && ${wob_show_brightness}";
  brightness_down_small = "${pkgs.brightnessctl}/bin/brightnessctl set 1%- && ${wob_show_brightness}";
  brightness_middle = "${pkgs.brightnessctl}/bin/brightnessctl set 50% && ${wob_show_brightness}";
  brightness_full = "${pkgs.brightnessctl}/bin/brightnessctl set 100% && ${wob_show_brightness}";

  # Media player.
  media_play_pause = "${pkgs.playerctl}/bin/playerctl play-pause";
  media_next = "${pkgs.playerctl}/bin/playerctl next";
  media_prev = "${pkgs.playerctl}/bin/playerctl previous";

  # Volume.
  wob_show_volume = "${wob} $(${pkgs.pamixer}/bin/pamixer --get-volume)";
  volume_up = "${pkgs.pamixer}/bin/pamixer -ui 10 && ${wob_show_volume}";
  volume_down = "${pkgs.pamixer}/bin/pamixer -ud 10 && ${wob_show_volume}";
  volume_up_small = "${pkgs.pamixer}/bin/pamixer -ui 1 && ${wob_show_volume}";
  volume_down_small = "${pkgs.pamixer}/bin/pamixer -ud 1 && ${wob_show_volume}";
  volume_toggle_mute = "${pkgs.pamixer}/bin/pamixer --toggle-mute && (${pkgs.pamixer}/bin/pamixer --get-mute && ${wob} 0) || ${wob_show_volume}";
  mic_mute = "${pkgs.pulseaudioFull}/bin/pactl set-source-mute @DEFAULT_SINK@ toggle";
  volume_control = "${pkgs.pavucontrol}/bin/pavucontrol";
  bluetooth_control = "${pkgs.blueman}/bin/blueman-applet";

  # Screenshots.
  screenshot_copy_screen = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy active";
  screenshot_copy_region = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy area";
  screenshot_save_screen = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save active ~/Pictures/Screenshots/`date +%Y-%m-%d_%H:%M:%S`.png";
  screenshot_save_region = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save area ~/Pictures/Screenshots/`date +%Y-%m-%d_%H:%M:%S`.png";

  # Notifications.
  notifications_dismiss_all = "${pkgs.mako}/bin/makoctl dismiss --all";

  # Status bar.
  # TODO: `.waybar-wrapped`
  hide_waybar = "${pkgs.killall}/bin/killall -SIGUSR1 .waybar-wrapped";
  reload_waybar = "systemctl restart --user waybar.service";

  # Idle/lock commands.
  lock_cmd = "${pkgs.swaylock}/bin/swaylock -F -f -e -K -l -i ~/.background-image -c '#000000'";
  idle_cmd = ''${pkgs.swayidle}/bin/swayidle -w \
    timeout 300 "${lock_cmd}" \
    timeout 600 "swaymsg 'output * dpms off'" \
    resume "swaymsg 'output * dpms on'" \
    before-sleep "${lock_cmd}"'';
}
