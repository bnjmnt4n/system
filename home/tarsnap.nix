{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tarsnap
    (pkgs.writeTextFile {
      name = "tarsnap.conf";
      destination = "/etc/tarsnap.conf";
      text = pkgs.lib.readFile ../nixos/tarsnap/tarsnap.conf;
    })
  ];
}
