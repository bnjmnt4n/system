{ pkgs, ... }:

let
  commands = import ../../lib/commands.nix { inherit pkgs; };
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
in
{
  # Wayland-based status bar.
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = pkgs.lib.readFile ./styles.css;
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
      modules-right = [ "custom/wf-recorder" "idle_inhibitor" "cpu" "memory" "network" "backlight" "pulseaudio" "battery" "clock" "tray" ];
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
          on-scroll-down = commands.brightness_down_small;
          on-scroll-up = commands.brightness_up_small;
          on-click = commands.brightness_full;
          on-click-right = commands.brightness_middle;
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
          on-scroll-down = commands.volume_down_small;
          on-scroll-up = commands.volume_up_small;
          on-click = commands.volume_toggle_mute;
          on-click-right = commands.volume_control;
          on-click-middle = commands.bluetooth_control;
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
        "custom/wf-recorder" = {
          format = "{}";
          return-type = "json";
          interval = "once";
          exec = ''pgrep wf-recorder >/dev/null && \
                    echo '{"text": "","tooltip":"Stop recording","class":"recording"}' || \
                    echo '{"text": "⏺","tooltip":"Start recording"}' '';
          on-click = "${scripts.screen-record}/bin/screen-record";
          on-click-right = "${scripts.screen-record}/bin/screen-record --check";
          signal = 8;
        };
      };
    }];
  };
}
