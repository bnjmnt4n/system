{ pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./waybar.nix
    ./mako.nix
    ./gammastep.nix
  ];

  home.packages = with pkgs; [
    swaylock              # Lockscreen
    swayidle
    xwayland              # For legacy Xorg-based apps

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
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };
}
