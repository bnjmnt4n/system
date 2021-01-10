{ pkgs, inputs, system, ... }:

{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlay
    inputs.nixpkgs-wayland.overlay
    inputs.nur.overlay
    (self: super: {
      naersk = inputs.naersk.lib.${system};
      firefox = inputs.nixpkgs-firefox.legacyPackages.${system}.firefox;
      firefox-nightly = inputs.firefox-nightly.packages.${system}.firefox-nightly-bin;
    })
    (import ./packages.nix)
  ];
}
