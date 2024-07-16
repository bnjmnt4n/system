{ pkgs, inputs ? { } }:

{
  # Copied from https://github.com/terlar/nix-config/blob/570134ba7007f68e058855e0d6a1677a9dc3fa27/lib/scripts.nix
  switchNixos = pkgs.writeShellScriptBin "swn" ''
    set -euo pipefail
    platform=$(uname)
    if [ "$platform" == "Darwin" ]; then
      darwin-rebuild switch --flake . $@
    else
      sudo nixos-rebuild switch --flake . $@
    fi
  '';

  switchHome = pkgs.writeShellScriptBin "swh" ''
    set -euo pipefail
    export PATH=${with pkgs; lib.makeBinPath [ coreutils gitMinimal jq nix ]}
    usr="''${1:-$USER}"
    hst=$(uname -n)
    attr="''${usr}@''${hst}"
    1>&2 echo "Switching Home Manager configuration for $usr on $hst"
    attrExists="$(nix eval --json .#homeConfigurations --apply 'x: (builtins.any (n: n == "'$attr'") (builtins.attrNames x))' 2>/dev/null)"
    if [ "$attrExists" != "true" ]; then
      1>&2 echo "No configuration found, aborting..."
      exit 1
    fi
    1>&2 echo "Building configuration..."
    out="$(nix build --json ".#homeConfigurations.$attr.activationPackage" | jq -r .[].outputs.out)"
    1>&2 echo "Activating configuration..."
    "$out"/activate
  '';

  nixFlakeInit = pkgs.writeShellScriptBin "nix-flake-init" ''
    nix flake init -t "${inputs.self}#''${1:-default}"
    echo "use flake" >> .envrc
    direnv allow .
  '';

  nixFlakeSync = pkgs.writeShellScriptBin "nix-flake-sync" ''
    [ -f flake.nix ] && ${pkgs.gnused}/bin/sed -i 's/nixpkgs.url *= *[^;]\+;/nixpkgs.url = "github:NixOS\/nixpkgs?rev=${inputs.nixpkgs.rev}";/g' flake.nix
    [ -f flake.nix ] && ${pkgs.gnused}/bin/sed -i 's/flake-utils.url *= *[^;]\+;/flake-utils.url = "github:numtide\/flake-utils?rev=${inputs.flake-utils.rev}";/g' flake.nix
    [ -f .envrc ] && direnv allow .
  '';

  # TODO: setup encrypted environment variables on WSL.
  setupResticEnv = pkgs.writeScriptBin "restic-env" ''
    #!/usr/bin/env fish

    set -x RESTIC_REPOSITORY (${pkgs.age}/bin/age --decrypt -i ~/.ssh/id_ed25519 ${../secrets/b2-repo.age})
    set -x B2_ACCOUNT_ID (${pkgs.age}/bin/age --decrypt -i ~/.ssh/id_ed25519 ${../secrets/b2-account-id.age})
    set -x B2_ACCOUNT_KEY (${pkgs.age}/bin/age --decrypt -i ~/.ssh/id_ed25519 ${../secrets/b2-account-key.age})
  '';

  setupResticEnvNew = pkgs.writeScript "setup-restic-env" ''
    #!/usr/bin/env fish

    set yq ${pkgs.yq-go}/bin/yq
    set REPO $argv[1]

    if isatty stdin
      echo "Please provide repository listings"
      exit 1
    else
      cat - | read -z FILE
    end

    if test -z "$REPO"
      echo "Please specify repository name"
      exit 1
    end

    if [ (echo $FILE | REPO="$REPO" $yq "has(env(REPO))") != "true" ]
      echo "Could not find repository $REPO"
      exit 1
    end

    echo $FILE | REPO="$REPO" $yq ".[env(REPO)].env" -o shell | read -z ENV_VARS
    export (echo $ENV_VARS | xargs -L 1)

    export RESTIC_REPOSITORY=(echo $FILE | REPO="$REPO" $yq ".[env(REPO)].repository")

    if [ (echo $FILE | REPO="$REPO" $yq '.[env(REPO)] | has("password")') = "true" ]
      set PASSWORD (echo $FILE | REPO="$REPO" $yq ".[env(REPO)].password")
      export RESTIC_PASSWORD_COMMAND="echo $PASSWORD"
    end
  '';

  backupDirectory = tarsnap: pkgs.writeShellScriptBin "backup-directory" ''
    set -euox pipefail
    ${tarsnap}/bin/tarsnap -c -f "$(basename "$1")-$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)" $1
  '';
}
