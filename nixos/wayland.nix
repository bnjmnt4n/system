{ lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    swaylock              # Lockscreen
    swayidle
    xwayland              # For legacy Xorg-based apps
    waybar                # Status bar
    mako                  # Notification daemon

    # TODO: not being used currently.
    wofi

    brightnessctl
    jq
    rofi
    wl-clipboard

    # Screenshots/screen-recording
    grim
    slurp
    sway-contrib.grimshot
    wf-recorder

    (
      pkgs.writeTextFile {
        name = "startsway";
        destination = "/bin/startsway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
        '';
      }
    )
  ];

  # Sway window manager.
  programs.sway = {
    enable = true;
    extraPackages = [];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND="1";
      export MOZ_USE_XINPUT2="1";
      export XDG_CURRENT_DESKTOP="sway";
      export XDG_SESSION_TYPE="wayland";
    '';
  };

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Wayland-based status bar.
  programs.waybar.enable = true;

  # Screen colour temperature management.
  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
  };
}
