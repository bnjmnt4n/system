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
        "is_wip_commit_description(description)" = ''
          !description ||
          description.first_line().lower().starts_with("wip:") ||
          description.first_line().lower().starts_with("wip") && description.first_line().lower().ends_with("wip")
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
        log_oneline = ''
          if(root,
            format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              concat(
                separate(" ",
                  format_short_change_id_with_hidden_and_divergent_info(self),
                  if(author.email(), author.username(), email_placeholder),
                  format_timestamp(committer.timestamp()),
                  bookmarks,
                  tags,
                  working_copies,
                  if(git_head, label("git_head", "git_head()")),
                  format_short_commit_id(commit_id),
                  if(conflict, label("conflict", "conflict")),
                  if(empty,
                    label(
                      separate(" ",
                        if(immutable, "immutable"),
                        if(hidden, "hidden"),
                        if(self.contained_in("trunk()"), "trunk"),
                        if(is_wip_commit_description(description), "wip"),
                        "empty",
                      ),
                      "(empty)"
                    )),
                  if(description,
                    label(
                      separate(" ",
                        if(self.contained_in("trunk()"), "trunk"),
                        if(is_wip_commit_description(description), "wip")),
                      description.first_line()),
                    label(
                      separate(" ",
                        if(self.contained_in("trunk()"), "trunk"),
                        "wip",
                        if(empty, "empty")),
                      description_placeholder)
                  )
                ) ++ "\n",
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
                  bookmarks,
                  tags,
                  working_copies,
                  if(git_head, label("git_head", "git_head()")),
                  format_short_commit_id(commit_id),
                  if(conflict, label("conflict", "conflict")),
                ) ++ "\n",
                separate(" ",
                  if(empty,
                    label(
                      separate(" ",
                        if(immutable, "immutable"),
                        if(hidden, "hidden"),
                        if(self.contained_in("trunk()"), "trunk"),
                        if(is_wip_commit_description(description), "wip"),
                        "empty",
                      ),
                      "(empty)"
                    )),
                  if(description,
                    label(
                      separate(" ",
                        if(self.contained_in("trunk()"), "trunk"),
                        if(is_wip_commit_description(description), "wip")),
                      description.first_line()),
                    label(
                      separate(" ",
                        if(self.contained_in("trunk()"), "trunk"),
                        "wip",
                        if(empty, "empty")),
                      description_placeholder)
                  )
                ) ++ "\n",
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

        "diverge(a, b)" = "heads(::a & ::b)::(a | b)";
      };
      revsets = {
        log = "ancestors(tree(@), 2) | trunk()";
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
        lall = [ "log" "-r" "all()" ];
        lo = [ "log" "-r" "overview()" ];
        lm = [ "log" "-r" "ancestors(mutable(), 2) | trunk()" ];
        lmu = [ "log" "-r" "ancestors(my_unmerged(), 2) | trunk()" ];
        lmur = [ "log" "-r" "ancestors(my_unmerged_remote(), 2) | trunk()" ];
        lnp = [ "log" "-r" "ancestors(not_pushed(), 2) | trunk()" ];
        ls = [ "log" "-r" "ancestors(stack(@), 2) | trunk()" ];
        s = [ "show" ];
        sg = [ "show" "--tool" "idea" ];
        sp = [ "show" "@-" ];
        showg = [ "show" "--tool" "idea" ];
        summary = [ "show" "--summary" ];
        sq = [ "squash" ];
        g = [ "git" ];
        gf = [ "git" "fetch" ];
        gp = [ "git" "push" ];
        abandon-merged = [ "abandon" "trunk().. & ..@ & empty() ~ @ ~ merges() ~ visible_heads()" ];
        simplify = [ "simplify-parents" "-r" "reachable(@, ~ ::trunk())" ];
        sync = [ "rebase" "-s" "roots(trunk()..@)" "-d" "trunk()" "--skip-emptied" ];
        sync-all = [ "rebase" "-s" "roots(mutable())" "-d" "trunk()" "--skip-emptied" ];
        rebaset = [ "rebase" "-d" "trunk()" ];
        new-from-previous-op = [ "new" "heads(new_visible_commits(@))" ];
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
  # TODO: move to completions directory?
  programs.fish.interactiveShellInit = pkgs.lib.readFile ./completions.fish;
}
