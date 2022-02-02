{ pkgs, ... }:

{
  environment.etc."/etc/tarsnap.conf".source = ./tarsnap.conf;

  environment.packages = [ pkgs.tarsnap ];
}
