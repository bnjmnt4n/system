{ config, lib, pkgs, ... }:

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
      snapshot = {
        auto-update-stale = true;
        auto-track = "glob:'**/*.*'";
      };
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
        bookmark_list = ''
          if(remote,
            if(tracked,
              "  " ++ separate(" ",
                label("bookmark", "@" ++ remote),
                format_tracked_remote_ref_distances(self),
              ) ++ format_ref_targets(self),
              label("bookmark", name ++ "@" ++ remote) ++ format_ref_targets(self),
            ),
            label("bookmark",
              if(get_repository_github_url(),
                hyperlink(concat(get_repository_github_url(), "/tree/", name), name),
                name)) ++
            if(present, format_ref_targets(self), " (deleted)"),
          ) ++ "\n"
        '';
        tag_list = ''
          label("tag",
            if(get_repository_github_url(),
              hyperlink(concat(get_repository_github_url(), "/releases/tag/", name), name),
              name)) ++
          format_ref_targets(self) ++ "\n"
        '';
        commit_summary = "format_commit_summary(self, bookmarks, tags)";
        draft_commit_description = "draft_commit_description_verbose";
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
            format_short_commit_id(root.commit_id()),
            label("root", "root()"),
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
                  "description",
                ),
                "(empty)"
              )),
            if(commit.description(),
              label(
                separate(" ",
                  if(commit.contained_in("trunk()"), "trunk"),
                  if(is_wip_commit_description(commit.description()), "wip")),
                commit.description().first_line()),
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
        "format_ref_targets(ref)" = ''
          if(ref.conflict(),
            separate("\n",
              " " ++ label("conflict", "(conflicted)") ++ ":",
              ref.removed_targets().map(|c| "  - " ++ format_commit_summary(c)).join("\n"),
              ref.added_targets().map(|c| "  + " ++ format_commit_summary(c)).join("\n"),
            ),
            ": " ++ format_commit_summary(ref.normal_target()),
          )
        '';
        "format_commit_summary(commit)" = ''
          separate(" ",
            format_short_change_id_with_hidden_and_divergent_info(commit),
            format_commit_id(commit),
            separate(" ",
              if(commit.conflict(), label("conflict", "(conflict)")),
              format_commit_description(commit),
            ),
          )
        '';
        "format_commit_summary(commit, bookmarks, tags)" = ''
          separate(" ",
            format_short_change_id_with_hidden_and_divergent_info(commit),
            format_commit_id(commit),
            separate(commit_summary_separator,
              format_commit_bookmarks(bookmarks),
              format_commit_tags(tags),
              separate(" ",
                if(commit.conflict(), label("conflict", "(conflict)")),
                format_commit_description(commit),
              ),
            ),
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
        # TODO: This wrongly links to unpushed local tags.
        "format_commit_tags(tags)" = ''
          if(get_repository_github_url(),
            tags.map(
              |tag| if(
                tag.remote() == "origin" || tag.remote() == "",
                hyperlink(concat(get_repository_github_url(), "/releases/tag/", tag.name()), tag),
                tag
              )
            ),
            tags
          )
        '';
        draft_commit_description = ''
          concat(
            description,
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.summary()),
            ),
          )
        '';
        draft_commit_description_verbose = ''
          concat(
            description,
            separate("\n",
              "\nJJ: This commit contains the following changes:",
              indent("JJ:     ", diff.summary()),
              "JJ: ignore-rest",
              diff.git(),
            )
          )
        '';
        log_oneline = ''
          if(root,
            format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              separate(" ",
                format_short_change_id_with_hidden_and_divergent_info(self),
                format_commit_id(self),
                if(author.email(), author.email().local(), email_placeholder),
                format_timestamp(committer.timestamp()),
                format_commit_bookmarks(bookmarks),
                format_commit_tags(tags),
                working_copies,
                if(git_head, label("git_head", "git_head()")),
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
                  format_commit_id(self),
                  format_short_signature(author),
                  format_timestamp(committer.timestamp()),
                  format_commit_bookmarks(bookmarks),
                  format_commit_tags(tags),
                  working_copies,
                  if(git_head, label("git_head", "git_head()")),
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
                  format_commit_id(self),
                  format_short_signature(author),
                  format_timestamp(committer.timestamp()),
                  format_commit_bookmarks(bookmarks),
                  format_commit_tags(tags),
                  working_copies,
                  if(git_head, label("git_head", "git_head()")),
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
        dd = [ "diff" "--git" "--config=ui.pager='delta'" ];
        ddl = [ "diff" "--git" "--config=ui.pager='delta --line-numbers'" ];
        dt = [ "diff" "--tool" "difftastic" ];
        descd = [ "describe" "--config=templates.draft_commit_description=draft_commit_description" ];
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
        lp = [ "log" "-T" "log_compact_no_summary" "--patch" ];
        loneline = [ "log" "-T" "log_oneline" ];
        lpatch = [ "log" "-T" "log_compact_no_summary" "--patch" ];
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
        sync = [ "rebase" "-d" "trunk()" "--skip-emptied" ];
        synct = [ "rebase" "-s" "children(::trunk()) & mine() & mutable() ~ archived()" "-d" "trunk()" "--skip-emptied" ];
        rebaset = [ "rebase" "-d" "trunk()" ];
        newt = [ "new" "trunk()" ];
      };
      merge-tools = {
        difftastic = {
          program = "${pkgs.difftastic}/bin/difft";
          diff-args = [ "--color=always" "$left" "$right" ];
          conflict-marker-style = "snapshot";
        };
        delta = {
          program = "${pkgs.delta}/bin/delta";
          diff-args = [ "--color-only" "$left" "$right" ];
        };
        mergiraf = {
          program = "${pkgs.mergiraf}/bin/mergiraf";
          merge-args = [ "merge" "$base" "$left" "$right" "-o" "$output" "--fast" ];
          merge-conflict-exit-codes = [ 1 ];
          conflict-marker-style = "git";
        };
        idea = {
          program =
            if pkgs.stdenv.hostPlatform.isDarwin
            then
              "${pkgs.writeShellScriptBin "idea-wrapper" ''
                ${pkgs.jetbrains.idea-community}/Applications/IntelliJ\ IDEA\ CE.app/Contents/MacOS/idea $@ 2> /dev/null
              ''}/bin/idea-wrapper"
            else "${pkgs.jetbrains.idea-community}/bin/idea-community";
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
      };
      colors = {
        # Change IDs.
        "change_id" = "magenta";
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
        "log email" = "#888888";
        "log timestamp" = "#888888";
        "log working_copy email" = "#888888";
        "log working_copy timestamp" = "#888888";

        # Descriptions.
        "wip description" = "yellow";
        "wip description placeholder" = "yellow";
        "trunk description" = "cyan";
        "immutable empty" = "default";
        "trunk empty" = "cyan";
        "hidden empty" = "black";
        "wip empty" = "yellow";
        "wip empty description placeholder" = "yellow";

        "working_copy" = { bold = false; };

        "working_copy empty" = { fg = "green"; bold = true; };
        "working_copy empty description placeholder" = "green";
        "working_copy description" = { fg = "green"; bold = true; };
        "working_copy description placeholder" = "green";
        "working_copy wip description placeholder" = "green";
        "working_copy wip empty description" = "green";
        "working_copy wip empty description placeholder" = "green";
        "log working_copy bookmark" = "green";
        "log working_copy bookmarks" = "green";
        "log working_copy local_bookmarks" = "green";
        "log working_copy remote_bookmarks" = "green";

        "log root" = "bright yellow";

        "node" = { fg = "magenta"; bold = true; };
        "node working_copy" = "green";
        "node immutable" = "default";
        "node conflict" = "red";
        "node wip" = "yellow";
      };
    };
  };
}
