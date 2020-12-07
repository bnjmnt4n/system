{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlay
    inputs.nixpkgs-wayland.overlay
    inputs.nur.overlay
    (import ./fluminurs.nix)
  ];
}
