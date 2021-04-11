{ pkgs, ... }:

let
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
  wob = scripts.wob;

  wob_show_brightness = "${wob} $(${pkgs.light}/bin/light -G | cut -d'.' -f1)";
  brightness_up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+ && ${wob_show_brightness}";
  brightness_down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%- && ${wob_show_brightness}";
  brightness_middle = "${pkgs.brightnessctl}/bin/brightnessctl set 50% && ${wob_show_brightness}";
  brightness_full = "${pkgs.brightnessctl}/bin/brightnessctl set 100% && ${wob_show_brightness}";

  wob_show_volume = "${wob} $(${pkgs.pamixer}/bin/pamixer --get-volume)";
  volume_up = "${pkgs.pamixer}/bin/pamixer -ui 1 && ${wob_show_volume}";
  volume_down = "${pkgs.pamixer}/bin/pamixer -ud 1 && ${wob_show_volume}";
in
{
  # Wayland-based status bar.
  programs.waybar = {
    enable = true;
    style = pkgs.lib.readFile ./waybar.css;
    settings = [{
      layer = "top";
      position = "top";
      height = 20;
      output = [
        "eDP-1"
        "HDMI-A-1"
      ];
      modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
      modules-center = [];
      modules-right = [ "idle_inhibitor" "cpu" "memory" "network" "backlight" "pulseaudio" "battery" "clock" "tray" ];
      modules = {
        "sway/workspaces" = {
          all-outputs = true;
          disable-scroll-wraparound = true;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        network = {
          interface = "wlp0s20f3";
          format = "{ifname}";
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname} ";
          format-disconnected = "";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
        };
        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" ];
          interval = 60;
          on-scroll-down = brightness_down;
          on-scroll-up = brightness_up;
          on-click = brightness_full;
          on-click-right = brightness_middle;
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" ];
          };
          scroll-step = 1;
          on-scroll-down = volume_down;
          on-scroll-up = volume_up;
          on-click = "${pkgs.pamixer}/bin/pamixer --toggle-mute && (${pkgs.pamixer}/bin/pamixer --get-mute && ${wob} 0) || ${wob_show_volume}";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-click-middle = "${pkgs.blueman}/bin/blueman-applet";
        };
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        clock = {
          format-alt = "{:%a, %d %b %H:%M}";
        };
        tray = {
          icon-size = 15;
          spacing = 8;
        };
      };
    }];
  };
}
