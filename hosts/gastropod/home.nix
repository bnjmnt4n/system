{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/home.base.nix
    ../../modules/graphical.nix
  ];
}
