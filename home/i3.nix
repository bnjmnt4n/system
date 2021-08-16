{ config, pkgs, ... }:

let
  # Modifiers.
  modifier = "Mod4";
  alt = "Mod1";

  commands = import ../lib/commands.nix { inherit pkgs; };

  mode_system = "System: (e) logout, (s) suspend, (r) reboot, (S) shutdown, (R) UEFI";
in
{
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      inherit modifier;
      terminal = "xfce4-terminal";
      gaps = {
        top = 26;
      };
      fonts = {
        names = [ "Iosevka" ];
        size = 10.0;
      };
      focus.followMouse = true;
      defaultWorkspace = "workspace number 1";
      keybindings = {
        "${modifier}+Return" = "exec xfce4-terminal";

        # Keybindings for commonly used apps.
        "${modifier}+b" = "exec ${commands.browser}";
        "${modifier}+z" = "exec ${commands.browser_alt}";
        "${modifier}+c" = "exec ${commands.editor}";
        "${modifier}+n" = "exec ${commands.explorer}";
        "${modifier}+t" = "exec ${commands.telegram}";

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
        { command = "systemctl --user restart polybar"; always = true; notification = false; }
      ];
    };
  };
}
