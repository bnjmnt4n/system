{ pkgs, lib, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) "weekly";
      interval = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
    settings = {
      # Free up to 1GiB whenever there is less than 100MiB left.
      min-free = 100 * 1024 * 1024;
      max-free = 1024 * 1024 * 1024;

      keep-outputs = true;
      keep-derivations = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];

      # Binary caches.
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://tree-grepper.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "tree-grepper.cachix.org-1:Tm/owXM+dl3GnT8gZg+GTI3AW+yX1XFVYXspZa7ejHg="
      ];
    };
  };
}
