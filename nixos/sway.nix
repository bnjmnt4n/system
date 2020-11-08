{ pkgs, ... }:

# TODO: bindsym --locked and --release.
let
  # Modifiers.
  modifier = "Mod4";
  alt = "Mod1";

  # Applications.
  terminal = "${pkgs.alacritty}/bin/alacritty";
  browser = "${pkgs.firefox-wayland}/bin/firefox";
  editor = "${pkgs.emacsGccPgtk}/bin/emacsclient -c -a emacs";
  explorer = "${pkgs.xfce.thunar}/bin/thunar";
  telegram = "${pkgs.tdesktop}/bin/telegram-desktop";
  spotify = "${pkgs.spotify}/bin/spotify";

  # Launcher command.
  launcher = "${pkgs.wofi}/bin/wofi --show drun \"Applications\"";
  # TODO: get binary from package?
  find_files = "find-files";

  # Outputs.
  output_laptop = "eDP-1";

  # Media player.
  media_play_pause = "${pkgs.playerctl}/bin/playerctl play-pause";
  media_next = "${pkgs.playerctl}/bin/playerctl next";
  media_prev = "${pkgs.playerctl}/bin/playerctl previous";

  # Volume.
  volume_up = "${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
  volume_down = "${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
  volume_mute = "${pkgs.pulseaudioFull}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
  mic_mute = "${pkgs.pulseaudioFull}/bin/pactl set-source-mute @DEFAULT_SINK@ toggle";

  # Screen brightness.
  brightness_up = "${pkgs.brightnessctl}/bin/brightnessctl set 10%+";
  brightness_down = "${pkgs.brightnessctl}/bin/brightnessctl set 10%-";

  # Screenshots.
  screenshot_copy_screen = "${pkgs.sway-contrib.grimshot}/bin/grimshot copy active";
  screenshot_copy_region = "${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
  screenshot_save_screen = "${pkgs.sway-contrib.grimshot}/bin/grimshot save active ~/Pictures/Screenshots/`date +%Y-%m-%d_%H:%M:%S`.png";
  screenshot_save_region = "${pkgs.sway-contrib.grimshot}/bin/grimshot save area ~/Pictures/Screenshots/`date +%Y-%m-%d_%H:%M:%S`.png";

  # Notifications.
  notifications_dismiss = "${pkgs.mako}/bin/makoctl dismiss";
  notifications_dismiss_all = "${pkgs.mako}/bin/makoctl dismiss --all";

  # Status bar.
  waybar = "${pkgs.waybar}/bin/waybar";

  mode_system = "System: (l) lock, (e) logout, (s) suspend, (r) reboot, (S) shutdown, (R) UEFI";

  # Idle/lock commands.
  lock_cmd = "${pkgs.swaylock}/bin/swaylock -F -f -e -K -l -i ~/.background-image -c '#000000'";
  idle_cmd = ''${pkgs.swayidle}/bin/swayidle -w \
    timeout 300 "${lock_cmd}" \
    timeout 600 "swaymsg 'output * dpms off'" \
    resume "swaymsg 'output * dpms on'" \
    before-sleep "${lock_cmd}"'';
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    systemdIntegration = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    xwayland = true;
    config = rec {
      inherit modifier;
      inherit terminal;
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
      output = {
        "*" = {
          bg = "~/.background-image fill";
        };
        "${output_laptop}" = {
          scale = "1.5";
        };
      };
      focus.followMouse = "always";
      gaps = {
        smartGaps = true;
        smartBorders = "on";
        inner = 5;
      };
      window = {
        border = 0;
      };
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";

        # Keybindings for commonly used apps.
        "${modifier}+b" = "exec ${browser}";
        "${modifier}+c" = "exec ${editor}";
        "${modifier}+n" = "exec ${explorer}";
        "${modifier}+t" = "exec ${telegram}";
        "${modifier}+m" = "exec ${spotify}";

        # Wofi commands.
        "${modifier}+d" = "exec ${launcher}";
        "${modifier}+o" = "exec ${find_files}";

        # Media controls.
        "XF86AudioPlay" = "exec ${media_play_pause}";
        "XF86AudioNext" = "exec ${media_next}";
        "XF86AudioPrev" = "exec ${media_prev}";
        "${modifier}+bracketright" = "exec ${media_next}";
        "${modifier}+bracketleft" = "exec ${media_prev}";

        # Volume controls.
        "XF86AudioRaiseVolume" = "exec ${volume_up}";
        "XF86AudioLowerVolume" = "exec ${volume_down}";
        "XF86AudioMute" = "exec ${volume_mute}";
        "XF86AudioMicMute" = "exec ${mic_mute}";

        # Screen brightness controls.
        "XF86MonBrightnessUp" = "exec ${brightness_up}";
        "XF86MonBrightnessDown" = "exec ${brightness_down}";

        # Keybinding for screenshots.
        "Print" = "exec ${screenshot_copy_screen}";
        "Shift+Print" = "exec ${screenshot_copy_region}";
        "${modifier}+Print" = "exec ${screenshot_save_screen}";
        "${modifier}+Shift+Print" = "exec ${screenshot_save_region}";

        # Notifications
        "Control+Space" = "exec ${notifications_dismiss}";
        "Control+Shift+Space" = "exec ${notifications_dismiss_all}";

        # Kill focused window.
        "${modifier}+q" = "kill";

        # Window navigation.
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        # Move focused window.
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # Modify split orientation.
        "${modifier}+Shift+v" = "split h";
        "${modifier}+v" = "split v";

        # Enter fullscreen mode for the focused container.
        "${modifier}+f" = "fullscreen toggle";

        # Change container layout (stacked, tabbed, toggle split).
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        # Toggle tiling/floating.
        "${modifier}+Shift+space" = "floating toggle";

        # Change focus between tiling/floating windows.
        "${modifier}+space" = "focus mode_toggle";

        # Focus the parent container.
        "${modifier}+a" = "focus parent";

        # Switch to workspace.
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        # Move focused container to workspace.
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        # Scratchpad.
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus"       = "scratchpad show";

        # Shortcuts for cycling through workspaces.
        "${modifier}+Tab" = "workspace next";
        "${modifier}+Shift+Tab" = "workspace prev";
        "${alt}+Tab" = "workspace back_and_forth";

        # Reload, restart and exit sway.
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";

        # Lock.
        "${modifier}+Shift+q" = "exec ${lock_cmd}";

        # Modes.
        "${modifier}+r"  = "mode resize";
        "${modifier}+Shift+e"  = "mode \"${mode_system}\"";
      };
      modes = {
        resize = {
          "h" = "resize shrink width 10 px or 10 ppt";
          "j" = "resize grow height 10 px or 10 ppt";
          "k" = "resize shrink height 10 px or 10 ppt";
          "l" = "resize grow width 10 px or 10 ppt";
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";

          "Return" = "mode default";
          "Escape" = "mode default";
          "${modifier}+r"  = "mode default";
        };

        "${mode_system}" = {
          "l" = "exec ${lock_cmd}, mode default";
          "e" = "exit";
          "s" = "exec systemctl suspend, mode default";
          "r" = "exec systemctl reboot, mode default";
          "Shift+s" = "exec systemctl poweroff -i, mode default";
          "Shift+r" = "exec systemctl reboot --firmware-setup, mode default";

          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };
      bars = [{
        command = waybar;
      }];
      startup = [
        { always = true; command = "${pkgs.mako}/bin/mako"; }
        { command = "${idle_cmd}"; }
      ];
    };
  };
}
