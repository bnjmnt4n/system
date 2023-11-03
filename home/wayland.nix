{ pkgs, ... }:

let
  scripts = import ../lib/scripts.nix { inherit pkgs; };
in
{
  imports = [
    ./sway.nix
    ./waybar
    ./mako.nix
    ./wlsunset.nix
    ./wofi.nix
  ];

  # Used within sway configuration.
  home.packages = with pkgs; [
    swaylock # Lockscreen
    swayidle
    qt5.qtwayland

    jq
    wl-clipboard

    # Screenshots/screen-recording
    grim
    slurp
    sway-contrib.grimshot
    wf-recorder
    scripts.screen-record
  ];
}
