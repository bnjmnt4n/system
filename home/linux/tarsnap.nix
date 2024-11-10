{ pkgs, ... }:

let
  configFile = pkgs.writeTextFile {
    name = "tarsnap.conf";
    destination = "/etc/tarsnap.conf";
    text = pkgs.lib.readFile ../nixos/tarsnap/tarsnap.conf;
  };
  configuredTarsnap = pkgs.writeShellScriptBin "tarsnap" ''
    set -euo pipefail
    sudo ${pkgs.tarsnap}/bin/tarsnap --configfile ${configFile}/etc/tarsnap.conf $@
  '';
in
{
  home.packages = [
    configuredTarsnap
    (pkgs.scripts.backupDirectory configuredTarsnap)
  ];
}
