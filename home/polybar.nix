{ config, pkgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;

    # Based on https://github.com/k-vernooy/dotfiles/blob/5fbf19243050f3ba73f294ed47ddc7d8a0c992e5/config/polybar/config
    settings = {
      colors = {
        background = "#ba1e2137";
        foreground = "#e3eaf3";
        primary = "#02c084";
        secondary = "#65a2d9";
        tertiary = "#d07ef2";
        fourth = "#e5c246";
        alert = "#ed404c";
      };

      "bar/main" = {
        width = "100%";

        height = "36";
        radius = "0.0";

        override-redirect = true;
        wm-restack = "i3";

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        padding-left = 1;
        padding-right = 2;
        module-margin-left = 2;
        module-margin-right = 1;

        font-0 = "Hack Nerd Font:pixelsize=14:antialias=true;2.5";
        font-1 = "Hack Nerd Font:style=Regular:pixelsize=24:antialias=true;3";

        modules-left = "i3";
        modules-center = "xwindow";
        modules-right = "cpu memory audio wlan date";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";

        tray-position = "right";
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:50:...%";
      };

      "module/i3" = {
        type = "internal/i3";
        pin-workspaces = false;
        strip-wsnumbers = true;
        index-sort = true;
        enable-click = true;
        enable-scroll = true;
        wrapping-scroll = false;
        reverse-scroll = false;
        fuzzy-match = true;

        # ; format = <label-state>

        # ; label-focused = %icon%
        label-focused-foreground = "\${colors.fourth}";
        label-focused-padding = 1;

        # ; label-unfocused = ${self.label-focused}
        label-unfocused-foreground = "#0a7383";
        label-unfocused-padding = "\${self.label-focused-padding}";

        # ; label-visible = ${self.label-focused}
        label-visible-foreground = "#0a7383";
        label-visible-padding = "\${self.label-focused-padding}";

        # ; label-urgent = ${self.label-focused}
        label-urgent-foreground = "\${colors.alert}";
        label-urgent-padding = "\${self.label-focused-padding}";
      };

      "module/cpu" = {
        type = "internal/cpu";
      };

      "module/memory" = {
        type = "internal/memory";
      };

      "module/date" = {
        type = "internal/date";
        interval = 10.0;

        date = "";
        date-alt = "%b %d, %Y  ";
        time = "%I:%M";
        time-alt = "%H:%M:%S";

        format-prefix-foreground = "\${colors.foreground}";
        format-underline = "#0a6cf5";
        label = "%date%%time%";
      };


      "module/audio" = {
        type = "internal/pulseaudio";

        format-volume = "<ramp-volume> <label-volume>";
        label-volume-foreground = "\${colors.secondary}";
        ramp-volume-foreground = "\${colors.secondary}";
        label-volume = "%percentage%%";

        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";

        label-muted = "ﱝ";
        label-muted-foreground = "\${colors.secondary}";
      };

      settings = {
        screenchange-reload = true;
      };

      "global/wm" = {
        margin-bottom = 20;
      };
    };

    script = "polybar main &";
  };
}
