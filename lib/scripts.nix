# Copied from https://github.com/terlar/nix-config/blob/570134ba7007f68e058855e0d6a1677a9dc3fa27/lib/scripts.nix
{ pkgs }:

{
  switchNixos = pkgs.writeShellScriptBin "swn" ''
    set -euo pipefail
    sudo nixos-rebuild switch --flake . $@
  '';

  switchHome = pkgs.writeShellScriptBin "swh" ''
    set -euo pipefail
    export PATH=${with pkgs; lib.makeBinPath [ gitMinimal jq nixUnstable ]}
    usr="''${1:-$USER}"
    1>&2 echo "Switching Home Manager configuration for: $usr"
    usrExists="$(nix eval --json .#homeConfigurations --apply 'x: (builtins.any (n: n == "'$usr'") (builtins.attrNames x))' 2>/dev/null)"
    if [ "$usrExists" != "true" ]; then
      1>&2 echo "No configuration found, aborting..."
      exit 1
    fi
    1>&2 echo "Building configuration..."
    out="$(nix build --json ".#homeConfigurations.$usr.activationPackage" | jq -r .[].outputs.out)"
    1>&2 echo "Activating configuration..."
    "$out"/activate
  '';

  waylandSession = pkgs.writeShellScript "wayland-session" ''
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
  '';
}
