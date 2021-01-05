{ config, lib, pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./chromium.nix
  ];
}
