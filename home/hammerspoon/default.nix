{ pkgs, lib, ... }:

{
  home.file.".hammerspoon/init.lua".source = pkgs.substituteAll {
      src = ./init.lua;
      firefox = "${pkgs.firefox-bin}/Applications/Firefox.app";
      wezterm = "${pkgs.wezterm}/Applications/WezTerm.app";
    };
  home.file.".hammerspoon/utils.lua".source = ./utils.lua;
  home.activation.reloadHammerspoon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.hammerspoon}/bin/hs -c "hs.reload()"
    $DRY_RUN_CMD sleep 1
    $DRY_RUN_CMD ${pkgs.hammerspoon}/bin/hs -c "hs.console.clearConsole()"
  '';
}
