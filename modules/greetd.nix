# Based largely off https://github.com/bqv/nixrc/blob/7c7d4a75f03267c96d0194e27fa3b06fff9c35cc/profiles/wayland.nix.
{ config, lib, pkgs, ... }:

{
  environment.etc = {
    "greetd/config.toml".text = let
      sway_cmd = pkgs.writeShellScript "wayland-session" ''
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway

        export SDL_VIDEODRIVER=wayland
        # Requires `qt5.qtwayland`
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

        # Enlightenment
        export ELM_ENGINE=wayland_egl
        export ECORE_EVAS_ENGINE=wayland_egl

        # Fix for some Java AWT applications (e.g. Android Studio)
        export _JAVA_AWT_WM_NONREPARENTING=1

        export MOZ_ENABLE_WAYLAND=1
        export MOZ_DBUS_REMOTE=1
        export MOZ_USE_XINPUT2=1

        exec sway
      '';
    in ''
      [terminal]
      vt = 1

      [default_session]
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${sway_cmd}"
      user = "greeter"

      [initial_session]
      command = "${sway_cmd}"
      user = "bnjmnt4n"
    '';
  };

  systemd.services."autovt@tty1".enable = lib.mkForce false;
  systemd.services."getty@tty1".enable = lib.mkForce false;
  systemd.services.display-manager = lib.mkForce {
    enable = lib.mkForce true;
    description = "Greetd";

    wantedBy = [ "multi-user.target" ];
    wants = [ "systemd-user-sessions.service" ];
    after = [
      "systemd-user-sessions.service"
      "plymouth-quit-wait.service"
      "getty@tty1.service"
    ];
    conflicts = [ "getty@tty1.service" ];
    aliases = [ "greetd.service" ];

    serviceConfig = {
      ExecStart = lib.mkForce "${pkgs.greetd}/bin/greetd";

      IgnoreSIGPIPE = "no";
      SendSIGHUP = "yes";
      TimeoutStopSec = "30s";
      KeyringMode = "shared";

      # Wayland is way faster to start up
      StartLimitBurst = lib.mkForce "5";
    };

    startLimitIntervalSec = 30;
    restartTriggers = lib.mkForce [];
    restartIfChanged = false;
    stopIfChanged = false;
  };

  users.users.greeter.isSystemUser = true;

  security.pam.services.greetd = {
    allowNullPassword = true;
    startSession = true;
  };
}
