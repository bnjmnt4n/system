{pkgs, ...}: let
  yaml = pkgs.replaceVars ./karabiner.yaml {
    browser = "/Applications/Firefox.app";
    notes = "/Applications/Nix Apps/Obsidian.app";
    music = "/Applications/Spotify.app";
    privatebrowser = "/Applications/Mullvad Browser.app";
    sync = "/Applications/Nix Apps/Syncthing.app";
    stickies = "/System/Applications/Stickies.app";
    terminal = "/Applications/Nix Apps/Ghostty.app";
  };
in {
  xdg.configFile."karabiner/karabiner.json".source =
    pkgs.runCommand "karabiner.json"
    {
      nativeBuildInputs = [pkgs.yq-go];
      yaml = yaml;
    } ''
      yq -Poj <(cat "$yaml") > "$out"
    '';
}
