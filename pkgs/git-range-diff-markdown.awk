# Based on https://codeberg.org/strega-nil/dotfiles/src/commit/9a9b63936c6f1564b03803b64eaf55491270183e/scripts/range-diff.awk
BEGIN {
  has_printed = 0
  in_diff = 0
}
# -:  --------- > 1:  3ab9e098d cli config edit: Rollback to previous config when invalid TOML is saved
# 1   2         3 4   5         ...
/^ *(-|[1-9][0-9]*):  (--*|[a-f0-9][a-f0-9]*) [<>=!]/ {
  if (has_printed) {
    if (in_diff) {
      print "```\n"
    }
    print "</details>"
  } else {
    has_printed = 1
  }
  print "<details><summary>\n" $0 "\n</summary><br>\n"
  if ($3 ~ /!/) {
    print "```diff"
    in_diff = 1
  } else {
    in_diff = 0
  }
}
in_diff && /^    / {
  sub(/^    /, "")
  print $0
}
END {
  if (has_printed) {
    if (in_diff) {
      print "```\n"
    }
    print "</details>"
  }
}
