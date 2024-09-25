# Additional Fish completions for Jujutsu
# https://gist.github.com/bnjmnt4n/9f47082b8b6e6ed2b2a805a1516090c8

# TODO: passthru other args? E.g.. --at-operation, --repository
function __jj
  command jj --ignore-working-copy --color=never --quiet $argv 2> /dev/null
end

# Aliases
# Based on https://github.com/fish-shell/fish-shell/blob/cd71359c42f633d9d71a63591ae16d150407a2b2/share/completions/git.fish#L625.
#
# Aliases are stored in global variables.
# `__jj_aliases` is a list of all aliases and `__jj_alias_$alias` is the command line for the alias.
function __jj_add_alias
  set -l alias $argv[1]
  set -l alias_escaped (string escape --style=var -- $alias)
  set -g __jj_alias_$alias_escaped $argv
  set --append -g __jj_aliases $alias
end

__jj config list aliases -T 'concat(name, "\t", value, "\n")' --include-defaults | while read -l config_alias
  set -l parsed (string match --regex '^aliases\.(.+)\t(.*)$' --groups-only -- $config_alias)
  set -l alias $parsed[1]
  set -l command $parsed[2]
  set -l args $alias
  # Replace wrapping `[]` if any
  set -l command (string replace -r --all '^\[|]$' ""  -- $command)
  while test (string length -- $command) -gt 0
    set -l parsed (string match -r '^"((?:\\\"|[^"])*?)"(?:,\s)?(.*)$' --groups-only  -- $command)
    set --append args $parsed[1]
    set command $parsed[2]
  end
  __jj_add_alias $args
end

__jj_add_alias "ci" "commit"
__jj_add_alias "desc" "describe"
__jj_add_alias "op" "operation"
__jj_add_alias "st" "status"

# Resolve aliases that call another alias.
for alias in $__jj_aliases
  set -l handled $alias

  while true
    set -l alias_escaped (string escape --style=var -- $alias)
    set -l alias_varname __jj_alias_$alias_escaped
    set -l aliased_command $$alias_varname[1][2]
    set -l aliased_escaped (string escape --style=var -- $aliased_command)
    set -l aliased_varname __jj_alias_$aliased_escaped
    set -q $aliased_varname
    or break

    # Prevent infinite recursion
    contains $aliased_escaped $handled
    and break

    # Expand alias in cmdline
    set -l aliased_cmdline $$aliased_varname[1][2..-1]
    set --append aliased_cmdline $$alias_varname[1][3..-1]
    set -g $alias_varname $$alias_varname[1][1] $aliased_cmdline
    set --append handled $aliased_escaped
  end
end

function __jj_aliases_with_descriptions
  for alias in $__jj_aliases
    set -l alias_escaped (string escape --style=var -- $alias)
    set -l alias_varname __jj_alias_$alias_escaped
    set -l aliased_cmdline (string join " " -- $$alias_varname[1][2..-1] | string replace -r --all '\\\"' '"')
    printf "%s\talias: %s\n" $alias $aliased_cmdline
  end
end

# Based on https://github.com/fish-shell/fish-shell/blob/2d4e42ee93327b9cfd554a0d809f85e3d371e70e/share/functions/__fish_seen_subcommand_from.fish.
# Test to see if we've seen a subcommand from a list.
# This logic may seem backwards, but the commandline will often be much shorter than the list.
function __jj_seen_subcommand_from
  set -l cmd (commandline -opc)
  set -e cmd[1]

  # Check command line arguments first.
  for i in $cmd
    if contains -- $i $argv
      return 0
    end
  end

  # Check aliases.
  set -l alias $cmd[1]
  set -l alias_escaped (string escape --style=var -- $alias)
  set -l varname __jj_alias_$alias_escaped
  set -q $varname
  or return 1

  for i in $$varname[1][2..-1]
    if contains -- $i $argv
      return 0
    end
  end

  return 1
end

function __jj_changes
  __jj log --no-graph --limit 1000 -r $argv[1] \
    -T 'separate("\t", change_id.shortest(), if(description, description.first_line(), "(no description set)")) ++ "\n"'
end

function __jj_branches
  set -f filter $argv[1]
  if string length --quiet -- $argv[2]
    __jj bookmark list --all-remotes -r "$argv[2]" \
      -T "if($filter, name ++ if(remote, \"@\" ++ remote) ++ \"\t\" ++ if(normal_target, normal_target.change_id().shortest() ++ \": \" ++ if(normal_target.description(), normal_target.description().first_line(), \"(no description set)\"), \"(conflicted bookmark)\") ++ \"\n\")"
  else
    __jj bookmark list --all-remotes \
      -T "if($filter, name ++ if(remote, \"@\" ++ remote) ++ \"\t\" ++ if(normal_target, normal_target.change_id().shortest() ++ \": \" ++ if(normal_target.description(), normal_target.description().first_line(), \"(no description set)\"), \"(conflicted bookmark)\") ++ \"\n\")"
  end
end

function __jj_all_branches
  __jj_branches '!remote || !remote.starts_with("git")' $argv[1]
end

function __jj_local_bookmarks
  __jj_branches '!remote' ''
end

function __jj_remote_branches
  __jj_branches 'remote && !remote.starts_with("git")' ''
end

function __jj_all_changes
  if string length --quiet -- $argv[1]
    set -f REV $argv[1]
  else
    set -f REV "all()"
  end
   __jj_changes $REV; __jj_all_branches $REV
end

function __jj_mutable_changes
  set -f REV "mutable()"
  __jj_changes $REV; __jj_all_branches $REV
end

function __jj_revision_modified_files
  if test $argv[1] = "@"
    set -f suffix ""
  else
    set -l change_id (__jj log --no-graph --limit 1 -T 'change_id.shortest()')
    set -f suffix " in $change_id"
  end

  __jj diff -r $argv[1] --summary | while read -l line
    set -l file (string split " " -m 1 -- $line)
    switch $file[1]
      case M
       set -f change "Modified"
      case D
        set -f change "Deleted"
      case A
        set -f change "Added"
      case R
        set -f change "Renamed"
      case C
        set -f change "Copied"
    end
    printf "%s\t%s%s\n" $file[2] $change $suffix
  end
end

function __jj_remotes
  __jj git remote list | while read -l remote
    printf "%s\t%s\n" (string split " " -m 1 -- $remote)
  end
end

function __jj_operations
  __jj operation log --no-graph --limit 1000 -T 'separate("\t", id.short(), description) ++ "\n"'
end

function __jj_parse_revision
  set -l cmd (commandline -opc)
  set -e cmd[1]
  set -l return_next false
  set -l return_value 1

  # Check aliases.
  set -l alias $cmd[1]
  set -l alias_escaped (string escape --style=var -- $alias)
  set -l varname __jj_alias_$alias_escaped

  if set -q $varname
    set cmd $$varname[1][2..-1] $cmd[2..-1]
  end

  # Check command line arguments first.
  for i in $cmd
    if $return_next
      echo $i
      set return_value 0
    else if contains -- $i -r --revision --from -f
      set return_next true
    else
      set -l match (string match --regex '^(?:-r=?|--revision=|--from=|-f=?)(.+)\s*$' --groups-only -- $i)
      if set -q match[1]
        echo $match[1]
        set return_value 0
      end
    end
  end

  return $return_value
end

function __jj_revision_files
  set -l description (__jj log --no-graph --limit 1 -r $argv[1] -T 'change_id.shortest() ++ ": " ++ coalesce(description.first_line().substr(0, 30), "(no description set)")')
  __jj file list -r $argv[1] | while read -l file
    printf "%s\t%s\n" $file $description
  end
end

function __jj_revision_conflicted_files
  __jj resolve --list -r $argv[1] | while read -l line
    set -l file (string split " " -m 1 -- $line)
    printf "%s\t%s\n" $file[1] $file[2]
  end
end

function __jj_parse_revision_files
  set -l rev (__jj_parse_revision)
  if test $status -eq 1
    set rev "@"
  end
  __jj_revision_files $rev
end

function __jj_parse_revision_conflicted_files
  set -l rev (__jj_parse_revision)
  if test $status -eq 1
    set rev "@"
  end
  __jj_revision_conflicted_files $rev
end

function __jj_parse_revision_files_or_wc_modified_files
  set -l revs (__jj_parse_revision)
  if test $status -eq 1
    __jj_revision_modified_files "@"
  else
    for rev in $revs
      __jj_revision_files $rev
    end
  end
end

function __jj_parse_revision_modified_files_or_wc_modified_files
  set -l revs (__jj_parse_revision)
  if test $status -eq 1
    __jj_revision_modified_files "@"
  else
    for rev in $revs
      __jj_revision_modified_files $rev
    end
  end
end

# Aliases.
complete -f -c jj -n '__fish_use_subcommand' -a '(__jj_aliases_with_descriptions)'

# Files.
complete -f -c jj -n '__jj_seen_subcommand_from file; and __jj_seen_subcommand_from show' -ka '(__jj_parse_revision_files)'
complete -f -c jj -n '__jj_seen_subcommand_from file; and __jj_seen_subcommand_from annotate' -ka '(__jj_parse_revision_files)'
complete -f -c jj -n '__jj_seen_subcommand_from file; and __jj_seen_subcommand_from chmod' -ka '(__jj_parse_revision_files)'
complete -f -c jj -n '__jj_seen_subcommand_from commit' -ka '(__jj_revision_modified_files "@")'
complete -c jj -n '__jj_seen_subcommand_from diff' -ka '(__jj_parse_revision_files_or_wc_modified_files)'
complete -c jj -n '__jj_seen_subcommand_from interdiff' -ka '(__jj_parse_revision_files)'
complete -f -c jj -n '__jj_seen_subcommand_from resolve' -ka '(__jj_parse_revision_conflicted_files)'
complete -f -c jj -n '__jj_seen_subcommand_from restore' -ka '(__jj_parse_revision_files_or_wc_modified_files)'
complete -f -c jj -n '__jj_seen_subcommand_from split' -ka '(__jj_parse_revision_modified_files_or_wc_modified_files)'
complete -f -c jj -n '__jj_seen_subcommand_from squash' -ka '(__jj_parse_revision_modified_files_or_wc_modified_files)'
complete -f -c jj -n '__jj_seen_subcommand_from untrack' -ka '(__jj_parse_revision_files_or_wc_modified_files)'

# Revisions.
complete -f -c jj -n '__jj_seen_subcommand_from abandon' -ka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from backout' -s r -l revisions -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from backout' -s d -l destination -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from file; and __jj_seen_subcommand_from annotate' -s r -l revision -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from file; and __jj_seen_subcommand_from show' -s r -l revision -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from file; and __jj_seen_subcommand_from chmod' -s r -l revision -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from describe' -ka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from diff' -s r -l revision -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from diff' -l from -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from diff' -l to -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from diffedit' -s r -l revision -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from diffedit' -l from -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from diffedit' -l to -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from duplicate' -ka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from edit' -ka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from fix' -s s -l source -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from file; and __jj_seen_subcommand_from list' -s r -l revision -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from interdiff' -l from -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from interdiff' -l to -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from log' -s r -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from new' -ka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from new' -s A -l after -l insert-after -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from new' -s B -l before -l insert-before -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from obslog' -s r -l revision -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from parallelize' -ka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from rebase' -s r -l revisions -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from rebase' -s s -l source -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from rebase' -s b -l branch -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from rebase' -s d -l destination -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from rebase' -s A -l after -l insert-after -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from rebase' -s B -l before -l insert-before -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from resolve' -s r -l revision -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from restore' -l from -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from restore' -l to -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from restore' -s c -l changes-in -rka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from show; and not __jj_seen_subcommand_from file; and not __jj_seen_subcommand_from operation' -ka '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from simplify-parents' -s r -l revisions -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from simplify-parents' -s s -l source -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from rebase' -s s -l source -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from split' -s r -l revision -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from squash' -s r -l revision -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from squash' -l from -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from squash' -l to -l into -rka '(__jj_mutable_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from unsquash' -s r -l revision -rka '(__jj_mutable_changes)'

# Bookmarks
complete -f -c jj -n '__jj_seen_subcommand_from bookmark; and __jj_seen_subcommand_from move delete forget rename set m d f r s' -ka '(__jj_local_bookmarks)'
complete -f -c jj -n '__jj_seen_subcommand_from bookmark; and __jj_seen_subcommand_from track t' -ka '(__jj_branches "remote && !tracked" "")'
complete -f -c jj -n '__jj_seen_subcommand_from bookmark; and __jj_seen_subcommand_from untrack' -ka '(__jj_branches "remote && tracked && !remote.starts_with(\"git\")" "")'
complete -f -c jj -n '__jj_seen_subcommand_from bookmark; and __jj_seen_subcommand_from create move set c m s' -s r -l revision -kra '(__jj_all_changes)'
complete -f -c jj -n '__jj_seen_subcommand_from bookmark; and __jj_seen_subcommand_from move' -l from -rka '(__jj_changes "all()")'
complete -f -c jj -n '__jj_seen_subcommand_from bookmark; and __jj_seen_subcommand_from move' -l to -rka '(__jj_changes "all()")'

# Git.
complete -f -c jj -n '__jj_seen_subcommand_from git; and __jj_seen_subcommand_from push' -s c -l change -kra '(__jj_changes "all()")'
complete -f -c jj -n '__jj_seen_subcommand_from git; and __jj_seen_subcommand_from push' -s r -l revisions -kra '(__jj_changes "all()")'
complete -f -c jj -n '__jj_seen_subcommand_from git; and __jj_seen_subcommand_from fetch push' -s b -l bookmark -rka '(__jj_local_bookmarks)'
complete -f -c jj -n '__jj_seen_subcommand_from git; and __jj_seen_subcommand_from fetch push' -l remote -rka '(__jj_remotes)'
complete -f -c jj -n '__jj_seen_subcommand_from git; and __jj_seen_subcommand_from remote; and __jj_seen_subcommand_from remove rename set-url' -ka '(__jj_remotes)'

# Operations.
complete -f -c jj -l at-op -l at-operation -rka '(__jj_operations)'
complete -f -c jj -n '__jj_seen_subcommand_from undo' -ka '(__jj_operations)'
complete -f -c jj -n '__jj_seen_subcommand_from operation; and __jj_seen_subcommand_from abandon undo restore' -ka '(__jj_operations)'
