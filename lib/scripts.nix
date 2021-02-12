# Copied from https://github.com/terlar/nix-config/blob/570134ba7007f68e058855e0d6a1677a9dc3fa27/lib/scripts.nix
{ pkgs }:

{
  switchNixos = pkgs.writeShellScriptBin "switch-nixos" ''
    set -euo pipefail
    sudo nixos-rebuild switch --flake . $@
  '';

  switchHome = pkgs.writeShellScriptBin "switch-home" ''
    set -euo pipefail
    export PATH=${with pkgs; lib.makeBinPath [ gitMinimal jq nixUnstable ]}
    usr="''${1:-$USER}"
    1>&2 echo "Switching Home Manager configuration for: $usr"
    usrExists="$(nix eval --json .#homeConfigurations --apply 'x: (builtins.any (n: n == "'$usr'") (builtins.attrNames x))' 2>/dev/null)"
    if [ "$usrExists" != "true" ]; then
      1>&2 echo "No configuration found, aborting..."
      exit 1
    fi
    1>&2 echo "Building configuration..."
    out="$(nix build --json ".#homeConfigurations.$usr.activationPackage" | jq -r .[].outputs.out)"
    1>&2 echo "Activating configuration..."
    "$out"/activate
  '';
}
