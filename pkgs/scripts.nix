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
}
