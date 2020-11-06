{ pkgs, ... }:

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
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "idle_inhibitor" "network" "backlight" "pulseaudio" "battery" "clock" "tray" ];
      modules = {
        "sway/workspaces" = {
          all-outputs = true;
          disable-scroll-wraparound = true;
        };
        "sway/window" = {
          max-length = 50;
        };
        # TODO: fix idle inhibitor display.
        idle_inhibitor = {
          format = "{status} {icon}";
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
        };
        backlight = {
          interval = 30;
          on-scroll-down = "brightnessctl set 1%-";
          on-scroll-up = "brightnessctl set 1%+";
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
          on-click = "pavucontrol";
        };
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        clock = {
          format-alt = "{:%a, %d %b  %H:%M}";
        };
        tray = {
          icon-size = 15;
          spacing = 8;
        };
      };
    }];
  };
}
