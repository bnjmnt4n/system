{ writeScriptBin, coreutils, utillinux, jq, systemd, sway }:
# Kill the cgroup of the focused window
let
  script = writeScriptBin "kill-focused.sh" ''
    #!/bin/sh

    set -eux

    pid=$(${sway}/bin/swaymsg -t get_tree | ${jq}/bin/jq '.. | select(.type?) | select(.focused==true).pid')
    cgroup=$(${coreutils}/bin/cat "/proc/$pid/cgroup" | ${coreutils}/bin/cut -d: -f3- | ${utillinux}/bin/rev | ${coreutils}/bin/cut -d/ -f1 | ${utillinux}/bin/rev)

    ${systemd}/bin/systemctl --user kill "$cgroup"
  '';
in
"${script}/bin/kill-focused.sh"
