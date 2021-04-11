{ config, lib, pkgs, ... }:

let
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
  sway_cmd = pkgs.writeShellScript "sway-session" ''
    . ${scripts.waylandSession}

    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway

    exec sway
  '';
in
{
  services.greetd = {
    enable = true;
    restart = true;
    vt = 2;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --time --cmd ${sway_cmd}";
        user = "greeter";
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
}
