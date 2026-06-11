{
  pkgs,
  inputs ? {},
}: {
  switchNixos = pkgs.writeShellScriptBin "swn" ''
    set -euo pipefail
    platform=$(uname)
    if [ $platform == "Darwin" ]; then
      nh darwin switch . $@
    else
      nh os switch . $@
    fi
  '';

  switchHome = pkgs.writeShellScriptBin "swh" ''
    set -euo pipefail
    usr=$(whoami)
    hst=$(uname -n)
    configuration="$usr@$hst"
    nh home switch . --configuration $configuration $@
  '';

  nixFlakeInit = pkgs.writeShellScriptBin "nix-flake-init" ''
    set -euo pipefail
    ${pkgs.nix}/bin/nix flake init -t "${inputs.self}#''${1:-default}"
    ${pkgs.nix}/bin/nix flake lock --override-input nixpkgs github:NixOS/nixpkgs/${inputs.nixpkgs.rev}
    ${pkgs.coreutils}/bin/echo "use flake" >> .envrc
    ${pkgs.direnv}/bin/direnv allow .
  '';

  nixFlakeSync = pkgs.writeShellScriptBin "nix-flake-sync" ''
    set -euo pipefail
    ${pkgs.nix}/bin/nix flake lock --override-input nixpkgs github:NixOS/nixpkgs/${inputs.nixpkgs.rev}
    [ -f .envrc ] && ${pkgs.direnv}/bin/direnv allow .
  '';

  cloneRepo = pkgs.writeShellScriptBin "clone-repo" ''
    set -euo pipefail
    if [ $# -eq 0 ]; then
      echo "Usage: clone-repo username/repository"
      exit 1
    fi

    url=$1
    host=""
    path=""

    if [[ $url =~ ^[[:alnum:]_-]+/[[:alnum:]_.-]+$ ]]; then
      host="github.com"
      path=$url
      url="git@github.com:$path.git"
    elif [[ $url =~ ^https://([[:alnum:]_.-]+)/(.+)$ ]]; then
      host="''${BASH_REMATCH[1]}"
      path="''${BASH_REMATCH[2]%.git}"
    elif [[ $url =~ ^(ssh://)?[[:alnum:]_-]+@([[:alnum:]_.-]+):(.+)$ ]]; then
      host="''${BASH_REMATCH[2]}"
      path="''${BASH_REMATCH[3]%.git}"
    else
      echo "Usage: clone-repo username/repository"
      exit 1
    fi

    repo_path="$host/$path"

    cd "$HOME/code"
    ${pkgs.jujutsu}/bin/jj git clone $url $repo_path
    trunk=$(${pkgs.jujutsu}/bin/jj --repository $repo_path config get "revset-aliases.'trunk()'")
    ${pkgs.jujutsu}/bin/jj --repository $repo_path config set --repo "revset-aliases.'trunk()'" "present($trunk)"
    ${pkgs.jujutsu}/bin/jj --repository $repo_path debug index-changed-paths
  '';

  gitRangeDiffMarkdown = pkgs.writeShellScriptBin "git-range-diff-markdown" ''
    set -euo pipefail
    ${pkgs.git}/bin/git range-diff "$@" | ${pkgs.gawk}/bin/awk -f ${./git-range-diff-markdown.awk}
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
}
