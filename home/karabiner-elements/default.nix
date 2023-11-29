{ pkgs, ... }:

{
  xdg.configFile."karabiner/karabiner.json".source = pkgs.runCommand "karabiner.json"
    {
      nativeBuildInputs = [ pkgs.yq-go ];
      yaml = builtins.readFile ./karabiner.yaml;
    } ''
    yq -Poj <(echo "$yaml") > "$out"
  '';
}
