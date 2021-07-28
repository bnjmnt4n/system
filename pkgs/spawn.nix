{ writeScriptBin, resholve, utillinux, coreutils, systemd }:
let
  script = writeScriptBin "spawn.sh" ''
    #!/bin/sh

    set -eux
    program=$1

    exec ${systemd}/bin/systemd-run --user --scope --unit "run-$(${coreutils}/bin/basename "$program")-$(${utillinux}/bin/uuidgen)" "$@"
  '';
in
"${script}/bin/spawn.sh"
