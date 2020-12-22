{ pkgs, inputs, system, ... }:

{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlay
    inputs.nixpkgs-wayland.overlay
    inputs.nur.overlay
    (self: super: {
      firefox = inputs.nixpkgs-firefox.legacyPackages.${system}.firefox;
    })
    (import ./fluminurs.nix)
  ];
}
