# Based on https://github.com/berbiche/dotfiles/blob/ed8f6fab3ddb4d2967b4a452a22caa930ea0f440/profiles/sway/libinput.nix.
#
# Libinput is a tool that listens for raw input events from a touchpad and emits
# its own event. It makes it possible to use it in conjection with other tools
# like libinput-gestures or gebaard to run libinput and act on these events.
#
# This libinput{-gestures, gebaard} configuration inject keypresses with ydotool.
#
# Currently, the injected inputs are:
#   - Next workspace
#   - Previous workspace
#   - Next page in web browser history (Alt+Right)
#   - Previous page in web browser history (Alt+Left)

{ config, lib, pkgs, ... }:

let
  ydotool = "${pkgs.ydotool}/bin/ydotool";

  # This configuration also uses "natural scrolling" where in
  # swiping and moving your fingers moves the content, not the viewport
  # (like MacOS)
  configFile = pkgs.writeTextDir "gebaar/gebaard.toml" ''
    device all

    # Go to next workspace when swiping left with 4 fingers
    gesture swipe left  4 ${ydotool} key Super_L+o
    # Go to previous workspace when swiping right with 4 fingers
    gesture swipe right 4 ${ydotool} key Super_L+i

    # Gesture for Firefox
    # Go to next page in history when swiping left with 3 fingers
    gesture swipe left 3  ${ydotool} key Alt_L+Right
    # Go to previous page in history when swiping right with 3 fingers
    gesture swipe right 3 ${ydotool} key Alt_L+Left
  '';
in
{
  # https://github.com/NixOS/nixpkgs/issues/70471
  # Chown&chmod /dev/uinput to owner:root group:input mode:0660
  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = ''
    SUBSYSTEM=="misc", KERNEL=="uinput", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="input", MODE="0660"
  '';

  users.users.libinput-gestures = {
    group = "input";
    description = "libinput gestures/gebaard user";
    isSystemUser = true;
    inherit (config.users.users.nobody) home;
  };

  systemd.services.libinput-gestures = {
    description = "Touchpad gesture listener";
    reloadIfChanged = true;

    partOf = [ "graphical.target" ];
    requires = [ "graphical.target" ];
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures -c ${configFile}/gebaar/gebaard.toml";
      User = config.users.users.libinput-gestures.name;
      Group = config.users.users.libinput-gestures.group;
    };
  };
}
