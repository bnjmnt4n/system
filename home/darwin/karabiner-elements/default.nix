{pkgs, ...}: let
  yaml = pkgs.replaceVars ./karabiner.yaml {
    browser = "/Applications/Firefox.app";
    terminal = "/Applications/Ghostty.app";
    privatebrowser = "/Applications/Mullvad Browser.app";
    music = "/Applications/Spotify.app";
    notes = "/System/Applications/Stickies.app";
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
