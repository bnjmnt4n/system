{pkgs, ...}: let
  yaml = pkgs.replaceVars ./karabiner.yaml {
    firefox = "/Applications/Firefox.app";
    ghostty = "/Applications/Ghostty.app";
    spotify = "/Applications/Spotify.app";
    zed = "${pkgs.zed-editor}/Applications/Zed.app";
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
