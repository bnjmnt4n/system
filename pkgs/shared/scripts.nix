{
  pkgs,
  inputs ? {},
}: {
  # Copied from https://github.com/terlar/nix-config/blob/570134ba7007f68e058855e0d6a1677a9dc3fa27/lib/scripts.nix
  switchNixos = pkgs.writeShellScriptBin "swn" ''
    set -euo pipefail
    platform=$(uname)
    if [ "$platform" == "Darwin" ]; then
      sudo darwin-rebuild switch --flake . $@
    else
      sudo nixos-rebuild switch --flake . $@
    fi
  '';

  switchHome = pkgs.writeShellScriptBin "swh" ''
    set -euo pipefail
    export PATH=${with pkgs; lib.makeBinPath [coreutils gitMinimal jq nix]}
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
    ${pkgs.nix}/bin/nix flake init -t "${inputs.self}#''${1:-default}"
    ${pkgs.nix}/bin/nix flake lock --override-input nixpkgs github:NixOS/nixpkgs/${inputs.nixpkgs.rev}
    ${pkgs.coreutils}/bin/echo "use flake" >> .envrc
    ${pkgs.direnv}/bin/direnv allow .
  '';

  nixFlakeSync = pkgs.writeShellScriptBin "nix-flake-sync" ''
    ${pkgs.nix}/bin/nix flake lock --override-input nixpkgs github:NixOS/nixpkgs/${inputs.nixpkgs.rev}
    [ -f .envrc ] && ${pkgs.direnv}/bin/direnv allow .
  '';

  cloneRepo = pkgs.writeShellScriptBin "clone-repo" ''
    if [ $# -eq 0 ]; then
      echo "Usage: clone-repo username/repository"
      exit 1
    fi

    if ! [[ $1 =~ ^[[:alnum:]_-]+/[[:alnum:]_.-]+$ ]]; then
      echo "Usage: clone-repo username/repository"
      exit 1
    fi

    ${pkgs.jujutsu}/bin/jj git clone --colocate "git@github.com:$1.git" $1
    ${pkgs.jujutsu}/bin/jj --repository $1 config set --repo repo.github-url "https://github.com/$1"
    TRUNK=$(${pkgs.jujutsu}/bin/jj --repository $1 config get "revset-aliases.'trunk()'")
    ${pkgs.jujutsu}/bin/jj --repository $1 config set --repo "revset-aliases.'trunk()'" "present($TRUNK)"
  '';

  setupResticEnv = pkgs.writeScriptBin "setup-restic-env" ''
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

  backupDirectory = tarsnap:
    pkgs.writeShellScriptBin "backup-directory" ''
      set -euox pipefail
      ${tarsnap}/bin/tarsnap -c -f "$(basename "$1")-$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)" $1
    '';
}
