{ pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./waybar.nix
    ./mako.nix
    ./gammastep.nix
    ./wofi.nix
  ];

  # Used within sway configuration.
  home.packages = with pkgs; [
    swaylock              # Lockscreen
    swayidle
    xwayland              # For legacy Xorg-based apps
    qt5.qtwayland

    brightnessctl
    jq
    wl-clipboard
    killall

    # Screenshots/screen-recording
    grim
    slurp
    sway-contrib.grimshot
    wf-recorder
  ];
}
