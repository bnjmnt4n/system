{
  config,
  lib,
  pkgs,
  ...
}: let
  sway_cmd = pkgs.writeShellScript "sway-session" ''
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

    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway

    exec sway
  '';
in {
  services.greetd = {
    enable = true;
    restart = false;
    vt = 2;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --window-padding 1 --asterisks --time --cmd ${sway_cmd}";
        user = "greeter";
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
}
