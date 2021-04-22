{ pkgs }:

{
  # Copied from https://github.com/terlar/nix-config/blob/570134ba7007f68e058855e0d6a1677a9dc3fa27/lib/scripts.nix
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

  wob = pkgs.writeShellScript "wob" ''
    # returns 0 (success) if $1 is running and is attached to this sway session; else 1
    is_running_on_this_screen() {
      pkill -0 $1 || return 1
      for pid in $( pgrep $1 ); do
        WOB_SWAYSOCK="$( tr '\0' '\n' < /proc/$pid/environ | awk -F'=' '/^SWAYSOCK/ {print $2}' )"
        if [[ "$WOB_SWAYSOCK" == "$SWAYSOCK" ]]; then
          return 0
        fi
      done
      return 1
    }

    new_value=$1 # null or a percent; no checking!!

    wob_pipe=~/.cache/$( basename $SWAYSOCK ).wob

    [[ -p $wob_pipe ]] || mkfifo $wob_pipe

    # wob does not appear in $(swaymsg -t get_msg), so:
    is_running_on_this_screen wob || {
      tail -f $wob_pipe | ${pkgs.wob}/bin/wob &
    }

    [[ "$new_value" ]] && echo $new_value > $wob_pipe
  '';

  screen-record = let
    notify-send = "${pkgs.libnotify}/bin/notify-send";
    wf-recorder = "${pkgs.wf-recorder}/bin/wf-recorder";
    slurp = "${pkgs.slurp}/bin/slurp";
    swaymsg = "${pkgs.sway}/bin/swaymsg";
    jq = "${pkgs.jq}/bin/jq";
    killall = "${pkgs.killall}/bin/killall";
  in
  # Based on https://gist.github.com/gingkapls/33f7567900a32ceed4b27f0eae1ffcd8
  pkgs.writeScriptBin "screen-record" ''
    #!/bin/sh

    if [ "$1" == "--check" ]; then
      if [ -z $(pgrep wf-recorder) ]; then
        ${notify-send} "Recording ended"
        pkill -RTMIN+8 waybar
        exit 1
      else
        ${notify-send} "Recording in progress"
        pkill -RTMIN+8 waybar
        exit 0
      fi
    fi

    if [ -z $(pgrep wf-recorder) ]; then
      filename=$(date +%F_%T.mkv)

      # TODO: audio?
      # active=$(pacmd list-sources | awk 'c&&!--c;/* index*/{c=1}' | awk '{gsub(/<|>/,"",$0); print $NF}')

      echo "Recording to file: $filename"
      if [ "$1" == "-s" ]; then
        ${notify-send} "Recording starting..."
        ${wf-recorder} -f $HOME/Videos/Recordings/$filename -g "$(${slurp} -c "#FFFFFF")" >/dev/null 2>&1 &
        sleep 2
        while [ ! -z $(pgrep -x slurp) ]; do true; done
        pkill -RTMIN+8 waybar
      else
        if [ "$1" == "-w" ]; then
          ${notify-send} "Recording starting..."
          ${wf-recorder} -f $HOME/Videos/Recordings/$filename -g "$(${swaymsg} -t get_tree | ${jq} -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | ${slurp} -c "#FFFFFF" )" >/dev/null 2>&1 &
          sleep 2
          while [ ! -z $(pgrep -x slurp) ]; do true; done
          pkill -RTMIN+8 waybar
        else
          ${notify-send} "Recording started"
          ${wf-recorder} -f $HOME/Videos/Recordings/$filename >/dev/null 2>&1 &
          pkill -RTMIN+8 waybar
        fi
      fi
    else
      ${killall} -s SIGINT wf-recorder
      ${notify-send} "Recording completed"
      while [ ! -z $(pgrep -x wf-recorder) ]; do true; done
      pkill -RTMIN+8 waybar
    fi
  '';
}
