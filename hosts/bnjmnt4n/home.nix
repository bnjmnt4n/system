{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/home.base.nix
    ../../modules/desktop-env.nix
  ];
}
