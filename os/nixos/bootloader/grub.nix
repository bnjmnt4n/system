{
  config,
  lib,
  pkgs,
  ...
}: {
  # GRUB.
  # Based on https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows#EFI.

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = ["nodev"];
    version = 2;
    useOSProber = true;

    font = "${pkgs.iosevka}/share/fonts/truetype/iosevka-regular.ttf";
    fontSize = 32;
  };
}
