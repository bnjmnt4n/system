{ config, pkgs, ... }:

let
  # Modifiers.
  modifier = "Mod4";
  alt = "Mod1";

  commands = import ../lib/commands.nix { inherit pkgs; };
  scripts = import ../lib/scripts.nix { inherit pkgs; };

  touchpad_laptop = "1267:12608:MSFT0001:01_04F3:3140_Touchpad";
  mouse = "0:14373:USB_OPTICAL_MOUSE";
  output_laptop = "Chimei Innolux Corporation 0x14E5 0x00000000";
  output_mi_monitor = "Unknown Mi Monitor 2920000042565";

  mode_system = "System: (l) lock, (e) logout, (s) suspend, (r) reboot, (S) shutdown, (R) UEFI";
in
{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    xwayland = false;
    extraSessionCommands = ''
      . ${scripts.waylandSession}

      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
    '';
    config = rec {
      inherit modifier;
      terminal = commands.terminal;
      fonts = {
        names = [ "Iosevka" ];
        size = 10.0;
      };
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "${mouse}" = {
          scroll_factor = "1.5";
        };
        "${touchpad_laptop}" = {
          scroll_factor = "0.4";
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
      seat = {
        seat0 = with config.gtk.gtk3.extraConfig; {
          xcursor_theme = ''"${gtk-cursor-theme-name}" ${toString gtk-cursor-theme-size}'';
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
            command = "floating enable";
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
        ];
      };
      defaultWorkspace = "workspace number 1";
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+Return" = "exec ${terminal} --class floating-term";

        # Keybindings for commonly used apps.
        "${modifier}+b" = "exec ${commands.browser}";
        "${modifier}+z" = "exec ${commands.browser_alt}";
        "${modifier}+c" = "exec ${commands.editor}";
        "${modifier}+n" = "exec ${commands.explorer}";
        "${modifier}+t" = "exec ${commands.telegram}";
        "${modifier}+m" = "exec ${scripts.spotify}";
        "${modifier}+Shift+m" = "exec ${scripts.spotify_force_restart}";

        # Wofi commands.
        "${modifier}+d" = "exec ${commands.launcher}";
        "${modifier}+p" = "exec ${scripts.find_files}";

        # Media controls.
        "--locked XF86AudioPlay" = "exec ${commands.media_play_pause}";
        "--locked XF86AudioNext" = "exec ${commands.media_next}";
        "--locked XF86AudioPrev" = "exec ${commands.media_prev}";
        "--locked ${modifier}+backslash" = "exec ${commands.media_play_pause}";
        "--locked ${modifier}+bracketright" = "exec ${commands.media_next}";
        "--locked ${modifier}+bracketleft" = "exec ${commands.media_prev}";

        # Volume controls.
        "--locked XF86AudioRaiseVolume" = "exec ${commands.volume_up}";
        "--locked XF86AudioLowerVolume" = "exec ${commands.volume_down}";
        "--locked XF86AudioMute" = "exec ${commands.volume_toggle_mute}";
        "--locked XF86AudioMicMute" = "exec ${commands.mic_mute}";

        # Screen brightness controls.
        "--locked XF86MonBrightnessUp" = "exec ${commands.brightness_up}";
        "--locked XF86MonBrightnessDown" = "exec ${commands.brightness_down}";

        # Keybinding for screenshots.
        "--release Print" = "exec ${commands.screenshot_copy_screen}";
        "--release Shift+Print" = "exec ${commands.screenshot_copy_region}";
        "--release ${modifier}+Print" = "exec ${commands.screenshot_save_screen}";
        "--release ${modifier}+Shift+Print" = "exec ${commands.screenshot_save_region}";

        # Keybinding for screen recording.
        "--release Ctrl+Print" = "exec ${scripts.screen-record}/bin/screen-record";
        "--release Ctrl+Shift+Print" = "exec ${scripts.screen-record}/bin/screen-record -s";

        # Hide waybar.
        "${modifier}+grave" = "exec ${commands.hide_waybar}";
        "${modifier}+Shift+grave" = "exec ${commands.reload_waybar}";

        # Notifications
        "Control+Shift+Space" = "exec ${commands.notifications_dismiss_all}";

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
        "${modifier}+minus" = "scratchpad show";

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
        "${modifier}+Shift+q" = "exec ${commands.lock_cmd}";

        # Modify output scale.
        "${modifier}+Ctrl+Alt+equal" = "exec ${scripts.output_scale} +.1";
        "${modifier}+Ctrl+Alt+minus" = "exec ${scripts.output_scale} -.1";

        # Modes.
        "${modifier}+r" = "mode resize";
        "${modifier}+Shift+e" = ''mode "${mode_system}"'';
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
          "${modifier}+r" = "mode default";
        };

        "${mode_system}" = {
          "l" = "exec ${commands.lock_cmd}, mode default";
          "e" = "exit";
          "s" = "exec systemctl suspend, mode default";
          "r" = "exec systemctl reboot, mode default";
          "Shift+s" = "exec systemctl poweroff -i, mode default";
          "Shift+r" = "exec systemctl reboot --firmware-setup, mode default";

          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };
      bars = [ ];
      startup = [
        { always = true; command = "${commands.reload_waybar}"; }
        { always = true; command = "${pkgs.mako}/bin/mako"; }
        { always = true; command = "${scripts.gsettings_cmd}"; }
        { command = "${commands.idle_cmd}"; }
      ];
    };
  };

  services.kanshi = {
    enable = true;
    profiles = {
      laptop = {
        outputs = [
          {
            criteria = "${output_laptop}";
          }
        ];
      };
      multimonitor_mi = {
        outputs = [
          {
            criteria = "${output_mi_monitor}";
            scale = 1.0;
            mode = "1920x1080@75.002Hz";
            position = "0,0";
          }
          {
            criteria = "${output_laptop}";
            position = "1920,0";
          }
        ];
      };
    };
  };
}
