{ config, lib, pkgs, ... }:

{
  console.earlySetup = true;
  systemd.services.systemd-vconsole-setup.before = lib.mkForce [ "display-manager.service" ];

  console.font = toString (pkgs.ttf-console-font {
    fontfile = "${pkgs.iosevka}/share/fonts/truetype/iosevka-regular.ttf";
    dpi = 192;
    # NOTE: make sure that the font size is less than 32px. (Check with `file /path/to/font`)
    ptSize = 10;
  });
}
