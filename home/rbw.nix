{ config, lib, pkgs, ... }:

{
  programs.rbw = {
    enable = true;
    settings.email = "demoneaux@gmail.com";
  };
}
