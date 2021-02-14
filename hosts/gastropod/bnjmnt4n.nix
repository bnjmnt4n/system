{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/base.nix
    ../../modules/graphical.nix
  ];

  # TODO: remove?
  home.username = "bnjmnt4n";
  home.homeDirectory = "/home/bnjmnt4n";

  # Miscellaneous/temporary packages.
  home.packages = with pkgs; [
    jetbrains.idea-community
    openjdk
    qtspim
  ];
}
