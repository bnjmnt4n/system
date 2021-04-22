{ pkgs, ... }:

let
  # Modifiers.
  modifier = "Mod4";
  alt = "Mod1";

  font = "Iosevka 10";

  # Applications.
  terminal = "${pkgs.alacritty}/bin/alacritty";
  browser = "${pkgs.firefox}/bin/firefox";
  browser_alt = "${pkgs.chromium}/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland";
  editor = "${pkgs.emacsPgtkGcc}/bin/emacsclient -c -a emacs";
  explorer = "${pkgs.xfce.thunar}/bin/thunar";
  telegram = "${editor} -e '(=telegram)'";
  # TODO: spotifyd service seems wonky at times.
  # TODO: figure out a non-hacky solution to move alacritty to scratchpad and show it.
  spotify = pkgs.writeShellScript "spotify.sh" ''
    if ! systemctl --user is-active spotifyd >/dev/null; then
      systemctl --user start spotifyd
    fi
    ${terminal} --title spotify --class alacritty-spotify --command spt &
    sleep 1
    swaymsg scratchpad show
  '';
  spotify_force_restart = pkgs.writeShellScript "spotify_force_restart.sh" ''
    systemctl --user restart spotifyd
    ${terminal} --title spotify --class alacritty-spotify --command spt &
    sleep 1
    swaymsg scratchpad show
  '';

  # Launcher command.
  launcher = "${pkgs.wofi}/bin/wofi --show drun \"Applications\"";
  # Simple file finder.
  find_files = pkgs.writeShellScript "find-files.sh" ''
    cd ~
    FILE="$(fd . Desktop Documents Downloads Dropbox -E "!{*.srt,*.rar,*.txt,*.zip,*.nfo}" | wofi --dmenu)"
    [ -n "$FILE"] && xdg-open "$HOME/$FILE"
  '';

  # Outputs.
  output_laptop = "eDP-1";

  # Media player.
  media_play_pause = "${pkgs.playerctl}/bin/playerctl play-pause";
  media_next = "${pkgs.playerctl}/bin/playerctl next";
  media_prev = "${pkgs.playerctl}/bin/playerctl previous";

  scripts = import ../lib/scripts.nix { inherit pkgs; };
  wob = scripts.wob;

  # Volume.
  wob_show_volume = "${wob} $(${pkgs.pamixer}/bin/pamixer --get-volume)";
  volume_up = "${pkgs.pamixer}/bin/pamixer -ui 10 && ${wob_show_volume}";
  volume_down = "${pkgs.pamixer}/bin/pamixer -ud 10 && ${wob_show_volume}";
  volume_mute = "${pkgs.pamixer}/bin/pamixer --toggle-mute && (${pkgs.pamixer}/bin/pamixer --get-mute && ${wob} 0) || ${wob_show_volume}";
  mic_mute = "${pkgs.pulseaudioFull}/bin/pactl set-source-mute @DEFAULT_SINK@ toggle";

  # Screen brightness.
  wob_show_brightness = "${wob} $(${pkgs.light}/bin/light -G | cut -d'.' -f1)";
  brightness_up = "${pkgs.brightnessctl}/bin/brightnessctl set 10%+ && ${wob_show_brightness}";
  brightness_down = "${pkgs.brightnessctl}/bin/brightnessctl set 10%- && ${wob_show_brightness}";

  # Screenshots.
  screenshot_copy_screen = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy active";
  screenshot_copy_region = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy area";
  screenshot_save_screen = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save active ~/Pictures/Screenshots/`date +%Y-%m-%d_%H:%M:%S`.png";
  screenshot_save_region = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save area ~/Pictures/Screenshots/`date +%Y-%m-%d_%H:%M:%S`.png";

  # Notifications.
  notifications_dismiss_all = "${pkgs.mako}/bin/makoctl dismiss --all";

  # Status bar.
  waybar = "${pkgs.waybar}/bin/waybar";
  hide_waybar = "${pkgs.killall}/bin/killall -SIGUSR1 waybar";

  mode_system = "System: (l) lock, (e) logout, (s) suspend, (r) reboot, (S) shutdown, (R) UEFI";

  # Idle/lock commands.
  lock_cmd = "${pkgs.swaylock}/bin/swaylock -F -f -e -K -l -i ~/.background-image -c '#000000'";
  idle_cmd = ''${pkgs.swayidle}/bin/swayidle -w \
    timeout 300 "${lock_cmd}" \
    timeout 600 "swaymsg 'output * dpms off'" \
    resume "swaymsg 'output * dpms on'" \
    before-sleep "${lock_cmd}"'';

  # Configure GTK settings for Wayland.
  # Based on https://github.com/colemickens/nixcfg/blob/437393cc4036de8a1a80e968cb776448c1414cd5/mixins/sway.nix.
  gsettings="${pkgs.glib}/bin/gsettings";
  gsettings_script = pkgs.writeShellScript "gsettings-auto.sh" ''
    expression=""
    for pair in "$@"; do
      IFS=:; set -- $pair
      expressions="$expressions -e 's:^$2=(.*)$:${gsettings} set org.gnome.desktop.interface $1 \1:e'"
    done
    IFS=
    echo "" >/tmp/gsettings.log
    echo exec sed -E $expressions "''${XDG_CONFIG_HOME:-$HOME/.config}"/gtk-3.0/settings.ini &>>/tmp/gsettings.log
    eval exec sed -E $expressions "''${XDG_CONFIG_HOME:-$HOME/.config}"/gtk-3.0/settings.ini &>>/tmp/gsettings.log
  '';
  gsettings_cmd = ''${gsettings_script} \
    gtk-theme:gtk-theme-name \
    icon-theme:gtk-icon-theme-name \
    font-name:gtk-font-name \
    cursor-theme:gtk-cursor-theme-name'';
  # Change output scales incrementally.
  # Based on https://github.com/colemickens/nixcfg/blob/437393cc4036de8a1a80e968cb776448c1414cd5/mixins/sway.nix.
  output_scale_cmd = pkgs.writeShellScript "scale-wlr-outputs.sh" ''
    set -xeuo pipefail
    delta=''${1}
    scale="$(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq '.[] | select(.focused == true) | .scale')"
    printf -v scale "%.1f" "''${scale}"
    scale="$(echo "''${scale} ''${delta}" | ${pkgs.bc}/bin/bc)"
    swaymsg output "-" scale "''${scale}"
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    xwayland = true;
    extraSessionCommands = ''
      . ${scripts.waylandSession}

      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
    '';
    extraConfig = ''
      seat seat0 xcursor_theme "capitaine-cursors"
    '';
    config = rec {
      inherit modifier;
      inherit terminal;
      fonts = [ font ];
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
      output = {
        "*" = {
          background = "~/.background-image fill";
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
        commands = [
          {
            criteria = { app_id = "floating-term"; };
            command = "floating enable, opacity 0.95";
          }
          {
            criteria = { app_id = "alacritty-spotify"; };
            command = "floating enable, move scratchpad";
          }
          {
            criteria = { app_id = "mpv"; };
            command = "floating enable, sticky enable";
          }
          {
            criteria = { app_id = "pavucontrol"; };
            command = "floating enable, sticky enable, resize set width 400px 600px, move position cursor, move down 35";
          }
          {
            criteria = { title = "^(.*) Indicator"; };
            command = "floating enable";
          }
          # Zoom
          {
            criteria = { title = "^Zoom Meeting$"; };
            command = "inhibit_idle visible";
          }
          {
            criteria = { title = "^Chat$|^Participants"; };
            command = "floating enable";
          }
          {
            criteria = { title = "^zoom$|Choose ONE of the audio conference options"; };
            command = "floating enable";
          }
          {
            criteria = { floating = ""; app_id = "emacs"; };
            command = "opacity 0.95";
          }
          {
            criteria = { floating = ""; app_id = "Alacritty"; };
            command = "opacity 0.95";
          }
        ];
      };
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+Return" = "exec ${terminal} --class floating-term";

        # Keybindings for commonly used apps.
        "${modifier}+b" = "exec ${browser}";
        "${modifier}+z" = "exec ${browser_alt}";
        "${modifier}+c" = "exec ${editor}";
        "${modifier}+n" = "exec ${explorer}";
        "${modifier}+t" = "exec ${telegram}";
        "${modifier}+m" = "exec ${spotify}";
        "${modifier}+Shift+m" = "exec ${spotify_force_restart}";

        # Wofi commands.
        "${modifier}+d" = "exec ${launcher}";
        "${modifier}+p" = "exec ${find_files}";

        # Media controls.
        "--locked XF86AudioPlay" = "exec ${media_play_pause}";
        "--locked XF86AudioNext" = "exec ${media_next}";
        "--locked XF86AudioPrev" = "exec ${media_prev}";
        "--locked ${modifier}+backslash" = "exec ${media_play_pause}";
        "--locked ${modifier}+bracketright" = "exec ${media_next}";
        "--locked ${modifier}+bracketleft" = "exec ${media_prev}";

        # Volume controls.
        "--locked XF86AudioRaiseVolume" = "exec ${volume_up}";
        "--locked XF86AudioLowerVolume" = "exec ${volume_down}";
        "--locked XF86AudioMute" = "exec ${volume_mute}";
        "--locked XF86AudioMicMute" = "exec ${mic_mute}";

        # Screen brightness controls.
        "--locked XF86MonBrightnessUp" = "exec ${brightness_up}";
        "--locked XF86MonBrightnessDown" = "exec ${brightness_down}";

        # Keybinding for screenshots.
        "--release Print" = "exec ${screenshot_copy_screen}";
        "--release Shift+Print" = "exec ${screenshot_copy_region}";
        "--release ${modifier}+Print" = "exec ${screenshot_save_screen}";
        "--release ${modifier}+Shift+Print" = "exec ${screenshot_save_region}";

        # Hide waybar.
        "${modifier}+grave" = "exec ${hide_waybar}";

        # Notifications
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

        # Move focused container to workspace, and switch to workspace.
        "${modifier}+Ctrl+1" = "move container to workspace number 1;  workspace number 1";
        "${modifier}+Ctrl+2" = "move container to workspace number 2;  workspace number 2";
        "${modifier}+Ctrl+3" = "move container to workspace number 3;  workspace number 3";
        "${modifier}+Ctrl+4" = "move container to workspace number 4;  workspace number 4";
        "${modifier}+Ctrl+5" = "move container to workspace number 5;  workspace number 5";
        "${modifier}+Ctrl+6" = "move container to workspace number 6;  workspace number 6";
        "${modifier}+Ctrl+7" = "move container to workspace number 7;  workspace number 7";
        "${modifier}+Ctrl+8" = "move container to workspace number 8;  workspace number 8";
        "${modifier}+Ctrl+9" = "move container to workspace number 9;  workspace number 9";
        "${modifier}+Ctrl+0" = "move container to workspace number 10; workspace number 10";

        # Scratchpad.
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus"       = "scratchpad show";

        # Shortcuts for cycling through workspaces.
        "${modifier}+Shift+Tab" = "workspace prev_on_output";
        "${modifier}+i" = "workspace prev_on_output";
        "${modifier}+Shift+i" = "move container to workspace prev_on_output";
        "${modifier}+Ctrl+i" = "move container to workspace prev_on_output; workspace prev_on_output";

        "${modifier}+Tab" = "workspace next_on_output";
        "${modifier}+o" = "workspace next_on_output";
        "${modifier}+Shift+o" = "move container to workspace next_on_output";
        "${modifier}+Ctrl+o" = "move container to workspace next_on_output; workspace next_on_output";

        "${alt}+Tab" = "workspace back_and_forth";
        "${modifier}+u" = "workspace back_and_forth";
        "${modifier}+Shift+u" = "move container to workspace back_and_forth";
        "${modifier}+Ctrl+u" = "move container to workspace back_and_forth; workspace back_and_forth";

        # Reload, restart and exit sway.
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";

        # Lock.
        "${modifier}+Shift+q" = "exec ${lock_cmd}";

        # Modify output scale.
        "${modifier}+Ctrl+Alt+equal" = "exec ${output_scale_cmd} +.1";
        "${modifier}+Ctrl+Alt+minus" = "exec ${output_scale_cmd} -.1";

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
        { always = true; command = "${gsettings_cmd}"; }
        { always = true; command = "${pkgs.mako}/bin/mako"; }
        { command = "${idle_cmd}"; }
      ];
    };
  };
}
