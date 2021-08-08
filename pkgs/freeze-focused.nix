{ writeScriptBin, resholve, coreutils, utillinux, jq, systemd, sway, gawk }:
# Freeze the cgroup of the focused window
let
  script = writeScriptBin "freeze-focused.sh" ''
    #!/bin/sh

    set -eux

    pid=$(${sway}/bin/swaymsg -t get_tree | ${jq}/bin/jq '.. | select(.type?) | select(.focused==true).pid')
    cgroup=$(${coreutils}/bin/cat "/proc/$pid/cgroup" | ${coreutils}/bin/cut -d: -f3- | ${utillinux}/bin/rev | ${coreutils}/bin/cut -d/ -f1 | ${utillinux}/bin/rev)

    state=$(${systemd}/bin/systemctl --user show "$cgroup" | \
      ${gawk}/bin/awk -v FS== '$1 == "FreezerState" { print $2; }')

    if [ "x$state" = "xfrozen" ]; then
      echo "Thawing $cgroup"
      ${systemd}/bin/systemctl --user thaw "$cgroup"
    elif [ "x$state" = "xrunning" ]; then
      echo "Freezing $cgroup"
      ${systemd}/bin/systemctl --user freeze "$cgroup"
    else
      echo "Unknown state: $state"
      exit 1
    fi
  '';
in
"${script}/bin/freeze-focused.sh"
