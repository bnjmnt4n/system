# Based largely off https://github.com/bqv/nixrc/blob/7c7d4a75f03267c96d0194e27fa3b06fff9c35cc/profiles/wayland.nix.
{ config, lib, pkgs, ... }:

{
  environment.etc = {
    "greetd/config.toml".text = let
      scripts = import ../../lib/scripts.nix { inherit pkgs; };
      sway_cmd = pkgs.writeShellScript "sway-session" ''
        . ${scripts.waylandSession}

        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway

        exec sway
      '';
    in ''
      [terminal]
      vt = 2

      [default_session]
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --time --cmd ${sway_cmd}"
      user = "greeter"
    '';
  };

  systemd.services.display-manager = lib.mkForce {
    enable = lib.mkForce true;
    description = "Greetd";

    wantedBy = [ "multi-user.target" ];
    wants = [ "systemd-user-sessions.service" ];
    after = [
      "systemd-user-sessions.service"
      "plymouth-quit-wait.service"
      "getty@tty2.service"
    ];
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
    enableGnomeKeyring = true;
  };
}
