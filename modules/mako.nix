{ pkgs, ... }:

{
  # Wayland notification daemon.
  programs.mako = {
    enable = true;
    layer = "overlay";
    anchor = "bottom-right";
    maxVisible = 3;
    font = "Source Sans Pro 14px";
    backgroundColor = "#285577CC";
    margin = "5";
    padding = "10";
    borderSize = 0;
    defaultTimeout = 5000;
  };
}
