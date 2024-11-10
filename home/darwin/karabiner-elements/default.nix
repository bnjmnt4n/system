{ pkgs, ... }:

let
  yaml = pkgs.substituteAll {
    src = ./karabiner.yaml;
    firefox = "${pkgs.firefox-bin}/Applications/Firefox.app";
    wezterm = "${pkgs.wezterm}/Applications/WezTerm.app";
    spotify = "${pkgs.spotify}/Applications/Spotify.app";
    zed = "${pkgs.zed-editor}/Applications/Zed.app";
  };
in
{
  xdg.configFile."karabiner/karabiner.json".source = pkgs.runCommand "karabiner.json"
    {
      nativeBuildInputs = [ pkgs.yq-go ];
      yaml = yaml;
    } ''
    yq -Poj <(cat "$yaml") > "$out"
  '';
}
