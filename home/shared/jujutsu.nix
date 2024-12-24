{ config, lib, pkgs, ... }:

let
  jj-fix-eslint = pkgs.writeShellScript "jj-fix-eslint" ''
    export PATH=${with pkgs; lib.makeBinPath [ coreutils jq ]}:"$PATH"
    FILE_CONTENTS=$(cat)
    ESLINT_OUTPUT_JSON=$(echo "$FILE_CONTENTS" | npx eslint --no-color --format json --stdin --stdin-filename "$1")
    if [ "$?" -ne 0 ]; then
      echo "$ESLINT_FIXED_OUTPUT" | npx eslint --stdin --stdin-filename "$1" 1>&2
      exit "$?"
    fi
    HAS_WARNINGS=$(echo "$ESLINT_OUTPUT_JSON" | jq -M -e ".[0].messages | length == 0 and .[0].fixableErrorCount + .[0].fixableWarningCount")
    if [ "$?" -eq 0 ]; then
      echo "$FILE_CONTENTS"
      exit 0
    fi
    ESLINT_FIXED_OUTPUT=$(echo "$FILE_CONTENTS" | npx eslint --no-color --fix-dry-run --format json --stdin --stdin-filename "$1" | jq -e -M ".[0].output" --raw-output)
    if [ "$?" -eq 0 ]; then
      # This tends to have false positives for some reason
      # echo "$ESLINT_FIXED_OUTPUT" | npx eslint --stdin --stdin-filename "$1" 1>&2
      echo "$ESLINT_FIXED_OUTPUT"
      exit 0
    else
      echo "$FILE_CONTENTS" | npx eslint --stdin --stdin-filename "$1" 1>&2
      echo "$FILE_CONTENTS"
      exit 1
    fi
  '';
in
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Benjamin Tan";
        email = "benjamin@dev.ofcr.se";
      };
      ui = {
        pager = "less -FRX";
        default-command = "log";
        always-allow-large-revsets = true;
        diff-editor = ":builtin";
        merge-editor = "idea";
      };
      diff.color-words.max-inline-alternation = 5;
      snapshot.auto-update-stale = true;
      templates = {
        log = "log_compact";
        log_node = ''
          coalesce(
            if(!self, label("elided", "⇋")),
            if(current_working_copy, label("working_copy", "@")),
            if(immutable, label("immutable", "◆")),
            if(conflict, label("conflict", "×")),
            if(is_wip_commit_description(description), label("wip", "○")),
            "○"
          )
        '';
      };
      template-aliases = {
        # Used to link to repository branches and commits.
        "get_repository_github_url()" = "''";
        "hyperlink(url, text)" = ''
          raw_escape_sequence("\e]8;;" ++ url ++ "\e\\") ++
          text ++
          raw_escape_sequence("\e]8;;\e\\")
	'';
        "is_wip_commit_description(description)" = ''
          !description ||
          description.first_line().lower().starts_with("wip:") ||
          description.first_line().lower() == "wip"
        '';
        "format_timestamp(timestamp)" = ''
          if(
            timestamp.before("1 month ago"),
            timestamp.format("%b %d %Y %H:%M"),
            timestamp.ago()
          )
        '';
        "format_short_change_id_with_hidden_and_divergent_info(commit)" = ''
          label(
            coalesce(
              if(commit.current_working_copy(), "working_copy"),
              if(commit.contained_in("trunk()"), "trunk"),
              if(commit.immutable(), "immutable"),
              if(commit.conflict(), "conflict"),
              if(is_wip_commit_description(commit.description()), "wip"),
            ),
            if(commit.hidden(),
              label("hidden",
                format_short_change_id(commit.change_id()) ++ " hidden"
              ),
              label(if(commit.divergent(), "divergent"),
                format_short_change_id(commit.change_id()) ++ if(commit.divergent(), "??")
              )
            )
          )
        '';
        "format_root_commit(root)" = ''
          separate(" ",
            label("immutable", format_short_change_id(root.change_id())),
            label("root", "root()"),
            format_short_commit_id(root.commit_id()),
            root.bookmarks()
          ) ++ "\n"
        '';
        "format_commit_description(commit)" = ''
          separate(" ",
            if(commit.empty(),
              label(
                separate(" ",
                  if(commit.immutable(), "immutable"),
                  if(commit.hidden(), "hidden"),
                  if(commit.contained_in("trunk()"), "trunk"),
                  if(is_wip_commit_description(commit.description()), "wip"),
                  "empty",
                ),
                "(empty)"
              )),
            if(commit.description(),
              label(
                separate(" ",
                  if(commit.contained_in("trunk()"), "trunk"),
                  if(is_wip_commit_description(commit.description()), "wip")),
                description.first_line()),
              label(
                separate(" ",
                  if(commit.contained_in("trunk()"), "trunk"),
                  "wip",
                  if(commit.empty(), "empty")),
                description_placeholder))
          )
        '';
        "format_commit_id(commit)" = ''
          if(get_repository_github_url() && commit.contained_in("..remote_bookmarks(remote=exact:'origin')"),
            hyperlink(
              concat(get_repository_github_url(), "/commit/", commit.commit_id()),
              format_short_commit_id(commit.commit_id()),
            ),
            format_short_commit_id(commit.commit_id()),
          )
        '';
        # TODO: This wrongly links to unpushed local bookmarks.
        "format_commit_bookmarks(bookmarks)" = ''
          if(get_repository_github_url(),
            bookmarks.map(
              |bookmark| if(
                bookmark.remote() == "origin" || bookmark.remote() == "",
                hyperlink(concat(get_repository_github_url(), "/tree/", bookmark.name()), bookmark),
                bookmark
              )
            ),
            bookmarks
          )
        '';
        log_oneline = ''
          if(root,
            format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              separate(" ",
                format_short_change_id_with_hidden_and_divergent_info(self),
                if(author.email(), author.email().local(), email_placeholder),
                format_timestamp(committer.timestamp()),
                format_commit_bookmarks(bookmarks),
                tags,
                working_copies,
                if(git_head, label("git_head", "git_head()")),
                format_commit_id(self),
                if(conflict, label("conflict", "conflict")),
                format_commit_description(self),
              ) ++ "\n",
            )
          )
        '';
        log_compact_no_summary = ''
          if(root,
            format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              concat(
                separate(" ",
                  format_short_change_id_with_hidden_and_divergent_info(self),
                  format_short_signature(author),
                  format_timestamp(committer.timestamp()),
                  format_commit_bookmarks(bookmarks),
                  tags,
                  working_copies,
                  if(git_head, label("git_head", "git_head()")),
                  format_commit_id(self),
                  if(conflict, label("conflict", "conflict")),
                ) ++ "\n",
                format_commit_description(self) ++ "\n",
              ),
            )
          )
        '';
        log_compact = ''
          if(root,
            format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              concat(
                separate(" ",
                  format_short_change_id_with_hidden_and_divergent_info(self),
                  format_short_signature(author),
                  format_timestamp(committer.timestamp()),
                  format_commit_bookmarks(bookmarks),
                  tags,
                  working_copies,
                  if(git_head, label("git_head", "git_head()")),
                  format_commit_id(self),
                  if(conflict, label("conflict", "conflict")),
                ) ++ "\n",
                format_commit_description(self) ++ "\n",
                if(!empty &&
                  (is_wip_commit_description(description) || current_working_copy),
                  diff.summary()
                ),
              ),
            )
          )
        '';
      };
      revset-aliases = {
        "at" = "@";
        "AT" = "@";

        "new_visible_commits(op)" = "at_operation(@-, at_operation(op, visible_heads()))..at_operation(op, visible_heads())";
        "new_hidden_commits(op)" = "at_operation(op, visible_heads())..at_operation(@-, at_operation(op, visible_heads()))";

        "base()" = "roots(roots(trunk()..@)-)";
        "tree(x)" = "reachable(x, ~ ::trunk())";
        "stack(x)" = "trunk()..x";
        "overview()" = "@ | ancestors(remote_bookmarks(), 2) | trunk() | root()";
        "my_unmerged()" = "mine() ~ ::trunk()";
        "my_unmerged_remote()" = "mine() ~ ::trunk() & remote_bookmarks()";
        "not_pushed()" = "remote_bookmarks()..";
        "archived()" = "(mine() & description(regex:'^archive($|:)'))::";
        "unarchived(x)" = "x ~ archived()";
        "diverge(x)" = "fork_point(x)::x";
      };
      revsets = {
        log = "ancestors(tree(@), 2) | trunk()";
        simplify-parents = "reachable(@, ~ ::trunk())";
        short-prefixes = "trunk()..";
      };
      aliases = {
        bl = [ "bookmark" "list" ];
        conflicts = [ "resolve" "--list" "-r" ];
        d = [ "diff" ];
        dg = [ "diff" "--tool" "idea" ];
        dd = [ "diff" "--git" "--config-toml=ui.pager='delta'" ];
        ddl = [ "diff" "--git" "--config-toml=ui.pager='delta --line-numbers'" ];
        diffg = [ "diff" "--tool" "idea" ];
        diffeditg = [ "diffedit" "--tool" "idea" ];
        l = [ "log" ];
        la = [ "log" "-r" "::@" ];
        lar = [ "log" "-r" "ancestors(mutable() & archived(), 2)" ];
        lall = [ "log" "-r" "all()" ];
        lo = [ "log" "-r" "overview()" ];
        lm = [ "log" "-r" "ancestors(unarchived(mutable()), 2) | trunk()" ];
        lmu = [ "log" "-r" "ancestors(unarchived(my_unmerged()), 2) | trunk()" ];
        lmur = [ "log" "-r" "ancestors(unarchived(my_unmerged_remote()), 2) | trunk()" ];
        lnp = [ "log" "-r" "ancestors(unarchived(not_pushed()), 2) | trunk()" ];
        ls = [ "log" "-r" "ancestors(unarchived(stack(@)), 2) | trunk()" ];
        lsummary = [ "log" "-T" "log_compact_no_summary" "--summary" ];
        n = [ "new" ];
        s = [ "show" ];
        sg = [ "show" "--tool" "idea" ];
        sp = [ "show" "@-" ];
        showg = [ "show" "--tool" "idea" ];
        summary = [ "show" "--summary" ];
        sq = [ "squash" ];
        g = [ "git" ];
        gf = [ "git" "fetch" ];
        gp = [ "git" "push" ];
        abandon-merged = [ "abandon" "trunk()..@ & empty() ~ @ ~ merges() ~ visible_heads()" ];
        bump = [ "describe" "--reset-author" "--no-edit" ];
        bumpt = [ "describe" "--reset-author" "--no-edit" "tree(@)" ];
        simplify = [ "simplify-parents" "-r" "reachable(@, ~ ::trunk())" ];
        sync = [ "rebase" "-d" "trunk()" "--skip-emptied" ];
        synct = [ "rebase" "-s" "children(::trunk()) & mutable() ~ archived()" "-d" "trunk()" "--skip-emptied" ];
        rebaset = [ "rebase" "-d" "trunk()" ];
        newt = [ "new" "trunk()" ];
      };
      merge-tools = {
        difft = {
          program = "${pkgs.difftastic}/bin/difft";
          diff-args = [ "--color=always" "$left" "$right" ];
        };
        delta = {
          program = "${pkgs.delta}/bin/delta";
          diff-args = [ "--color-only" "$left" "$right" ];
        };
        mergiraf = {
          program = "${pkgs.mergiraf}/bin/mergiraf";
          merge-args = ["merge" "$base" "$left" "$right" "-o" "$output" "--fast"];
          merge-conflict-exit-codes = [1];
          conflict-marker-style = "git";
        };
        idea = {
          program = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "${pkgs.jetbrains.idea-community}/Applications/IntelliJ IDEA CE.app/Contents/MacOS/idea";
          diff-args = [ "diff" "$left" "$right" ];
          edit-args = [ "diff" "$left" "$right" ];
          merge-args = [ "merge" "$left" "$right" "$base" "$output" ];
        };
      };
      signing = {
        sign-all = true;
        backend = "gpg";
        key = "A853F0716C413825";
      };
      fix.tools = {
        rustfmt = {
          command = [ "rustfmt" "--emit" "stdout" ];
          patterns = [ "glob:'**/*.rs'" ];
        };
        prettier = {
          command = [ "npx" "prettier" "--stdin-filepath=$path" ];
          patterns = [ "glob:'**/*.tsx'" "glob:'**/*.ts'" "glob:'**/*.jsx'" "glob:'**/*.js'" "glob:'**/*.css'" "glob:'**/*.html'" ];
        };
        # Disabling since it's kinda slow and I'm not even sure it's fully correct.
        # eslint = {
        #   command = [ jj-fix-eslint "$path" ];
        #   patterns = [ "glob:'**/*.tsx'" "glob:'**/*.ts'" "glob:'**/*.jsx'" "glob:'**/*.js'" ];
        # };
      };
      colors = {
        # Change IDs.
        "change_id" = "bright magenta";
        "trunk change_id" = "cyan";
        "working_copy change_id" = "green";
        "immutable change_id" = "default";
        "conflict change_id" = "red";
        "wip change_id" = "yellow";
        "hidden change_id" = "black";

        # Commit IDs.
        "commit_id" = "bright cyan";
        "commit_id prefix" = { bold = false; };
        "working_copy commit_id" = "bright cyan";
        "rest" = "bright black";

        # Commit author and timestamp.
        "log email" = "bright black";
        "log username" = "bright black";
        "log timestamp" = "bright black";
        "log working_copy timestamp" = "bright black";
        "log date" = "bright black";
        "log working_copy email" = "bright black";
        "log working_copy username" = "bright black";

        # Descriptions.
        "wip description" = "yellow";
        "wip description placeholder" = "yellow";
        "trunk description" = "cyan";
        "immutable empty" = "default";
        "trunk empty" = "cyan";
        "hidden empty" = "black";
        "wip empty" = "yellow";
        "wip empty description placeholder" = "yellow";
        "working_copy wip empty" = "green";
        "working_copy description" = "green";
        "working_copy description placeholder" = "green";
        "working_copy wip empty description placeholder" = "green";
        "working_copy wip description placeholder" = "green";

        "log working_copy" = { bold = false; };
        "log working_copy bookmark" = "green";
        "log working_copy bookmarks" = "green";
        "log working_copy local_bookmarks" = "green";
        "log working_copy remote_bookmarks" = "green";

        "log root" = "bright yellow";

        "node" = { fg = "bright magenta"; bold = true; };
        "node working_copy" = "green";
        "node immutable" = "default";
        "node conflict" = "red";
        "node wip" = "yellow";
      };
    };
  };
}
