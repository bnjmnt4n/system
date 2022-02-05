{ pkgs, ... }:

let
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
in
{
  environment.etc."/etc/tarsnap.conf".source = ./tarsnap.conf;

  environment.packages = [
    pkgs.tarsnap 
    (scripts.backupDirectory pkgs.tarsnap)
  ];
}
