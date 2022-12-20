{ pkgs, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      # Free up to 1GiB whenever there is less than 100MiB left.
      min-free = 100 * 1024 * 1024;
      max-free = 1024 * 1024 * 1024;

      keep-outputs = true;
      keep-derivations = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    trustedUsers = [ "root" "@wheel" ];
  };
}
