{ pkgs, ... }:

let
  configFile = pkgs.writeTextFile {
    name = "tarsnap.conf";
    destination = "/etc/tarsnap.conf";
    text = pkgs.lib.readFile ../nixos/tarsnap/tarsnap.conf;
  };
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
  configuredTarsnap = pkgs.writeShellScriptBin "tarsnap" ''
    set -euo pipefail
    sudo ${pkgs.tarsnap}/bin/tarsnap --configfile ${configFile}/etc/tarsnap.conf $@
  '';
in
{
  home.packages = [
    configuredTarsnap
    (scripts.backupDirectory configuredTarsnap)
  ];
}
