{
  pkgs,
  config,
  ...
}: let
  idea =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "${pkgs.writeShellScriptBin "idea-wrapper" ''
      ${pkgs.jetbrains.idea}/Applications/IntelliJ\ IDEA.app/Contents/MacOS/idea $@ 2> /dev/null
    ''}/bin/idea-wrapper"
    else "${pkgs.jetbrains.idea}/bin/idea-community";
in {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.programs.git.settings.user.name;
        email = config.programs.git.settings.user.email;
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
      signing = {
        backend = "ssh";
        key = "~/.ssh/signing.pub";
        behavior = "drop";
        backends.ssh.allowed-signers = "${config.xdg.configHome}/git/allowedsigners";
      };
      git.sign-on-push = true;
      hints.resolving-conflicts = false;
      # Used to link to repository branches and commits.
      repo.github-url = "";
      templates = {
        log = "log_compact";
        log_node = ''
          coalesce(
            if(!self, label("elided", "⇋")),
            if(current_working_copy, label("working_copy", "@")),
            if(immutable, label("immutable", "◆")),
            if(conflict, label("conflicted", "×")),
            if(is_wip_commit_description(description), label("wip", "○")),
            label("mutable", "○"),
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
              if(config("repo.github-url").as_string(),
                hyperlink(concat(config("repo.github-url").as_string(), "/tree/", name), name),
                name)) ++
            if(present, format_ref_targets(self), " (deleted)"),
          ) ++ "\n"
        '';
        tag_list = ''
          label("tag",
            if(config("repo.github-url").as_string(),
              hyperlink(concat(config("repo.github-url").as_string(), "/releases/tag/", name), name),
              name)) ++
          format_ref_targets(self) ++ "\n"
        '';
        commit_summary = "format_commit_summary(self, bookmarks, tags)";
        draft_commit_description = "draft_commit_description_verbose";
        show = "log_detailed";
      };
      template-aliases = {
        "is_wip_commit_description(description)" = ''
          !description ||
          description.first_line().lower().starts_with("wip:") ||
          description.first_line().lower() == "wip"
        '';
        "format_short_id(id)" = "id.shortest(7)";
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
              if(commit.conflict(), "conflicted"),
              if(is_wip_commit_description(commit.description()), "wip"),
              "mutable",
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
                  if(commit.immutable(), "immutable", "mutable"),
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
                  if(commit.immutable(), "immutable", "mutable"),
                  if(commit.contained_in("trunk()"), "trunk"),
                  if(is_wip_commit_description(commit.description()), "wip")),
                format_commit_description_first_line(commit.description().first_line())),
              label(
                separate(" ",
                  if(commit.immutable(), "immutable", "mutable"),
                  if(commit.contained_in("trunk()"), "trunk"),
                  "wip",
                  if(commit.empty(), "empty")),
                description_placeholder))
          )
        '';
        "format_commit_description_first_line(description)" = ''
          if(config("repo.github-url").as_string() && description.match(regex:'^.+ \(#\d+\)$'),
            description.replace(regex:' \(#\d+\)$', "") ++
              label("description",
                " (" ++ hyperlink(
                  concat(config("repo.github-url").as_string(),
                    "/pull/",
                    description.replace(regex:'^.+ \(#(\d+)\)$', "$1")),
                  description.replace(regex:'^.+ \((#\d+)\)$', "$1")
                ) ++ ")"),
            description)
        '';
        "format_commit_id(commit)" = ''
          if(config("repo.github-url").as_string() && commit.contained_in("..remote_bookmarks(remote=exact:'origin')"),
            hyperlink(
              concat(config("repo.github-url").as_string(), "/commit/", commit.commit_id()),
              format_short_commit_id(commit.commit_id()),
            ),
            format_short_commit_id(commit.commit_id()),
          )
        '';
        "format_long_commit_id(commit)" = ''
          if(config("repo.github-url").as_string() && commit.contained_in("..remote_bookmarks(remote=exact:'origin')"),
            hyperlink(
              concat(config("repo.github-url").as_string(), "/commit/", commit.commit_id()),
              commit.commit_id(),
            ),
            commit.commit_id(),
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
              if(commit.conflict(), label("conflicted", "(conflict)")),
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
                if(commit.conflict(), label("conflicted", "(conflict)")),
                format_commit_description(commit),
              ),
            ),
          )
        '';
        # TODO: This wrongly links to unpushed local bookmarks.
        "format_commit_bookmarks(bookmarks)" = ''
          if(config("repo.github-url").as_string(),
            bookmarks.map(
              |bookmark| if(
                bookmark.remote() == "origin" || !bookmark.remote(),
                hyperlink(concat(config("repo.github-url").as_string(), "/tree/", bookmark.name()), bookmark),
                bookmark
              )
            ),
            bookmarks
          )
        '';
        # TODO: This wrongly links to unpushed local tags.
        "format_commit_tags(tags)" = ''
          if(config("repo.github-url").as_string(),
            tags.map(
              |tag| if(
                tag.remote() == "origin" || !tag.remote(),
                hyperlink(concat(config("repo.github-url").as_string(), "/releases/tag/", tag.name()), tag),
                tag
              )
            ),
            tags
          )
        '';
        "format_short_signature(signature)" = ''
          if(signature.email(),
            hyperlink(concat("mailto:", signature.email()), signature.email()),
            email_placeholder
          )
        '';
        "format_detailed_signature(signature)" = ''
          coalesce(signature.name(), name_placeholder)
          ++ " <" ++ format_short_signature(signature) ++ ">"
          ++ " (" ++ format_timestamp(signature.timestamp()) ++ ")"
        '';
        draft_commit_description = ''
          concat(
            coalesce(description, "\n"),
            "\nJJ: Change ID: " ++ format_short_change_id(change_id),
            surround(
              "\nJJ:" ++
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.summary()),
            ),
          )
        '';
        draft_commit_description_verbose = ''
          concat(
            coalesce(description, "\n"),
            "\nJJ: Change ID: " ++ format_short_change_id(change_id),
            surround(
              "\nJJ:" ++
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.summary()),
            ),
            surround("\nJJ: ignore-rest\n", "", diff.git()),
          )
        '';
        annotate_header = ''
          if(first_line_in_hunk, surround("\n", "\n", separate("\n",
            separate(" ",
              format_short_change_id_with_hidden_and_divergent_info(commit),
              format_commit_id(commit),
              commit.description().first_line(),
            ),
            commit.committer().timestamp().local().format('%Y-%m-%d %H:%M:%S')
            ++ " "
            ++ commit.author(),
          ))) ++
          pad_start(4, line_number) ++ ": " ++
          content
        '';
        log_oneline = ''
          if(root,
            format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              separate(" ",
                format_short_change_id_with_hidden_and_divergent_info(self),
                format_commit_id(self),
                if(author.email(),
                  hyperlink(concat("mailto:", author.email()), author.email().local()),
                  email_placeholder
                ),
                format_timestamp(committer.timestamp()),
                format_commit_bookmarks(bookmarks),
                format_commit_tags(tags),
                working_copies,
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
        log_detailed = ''
          concat(
            "Commit ID: " ++ format_long_commit_id(self) ++ "\n",
            "Change ID: " ++ change_id ++ "\n",
            surround("Bookmarks: ", "\n",
              separate(" ", format_commit_bookmarks(local_bookmarks), format_commit_bookmarks(remote_bookmarks))),
            surround("Tags     : ", "\n", format_commit_tags(tags)),
            "Author   : " ++ format_detailed_signature(author) ++ "\n",
            "Committer: " ++ format_detailed_signature(committer)  ++ "\n",
            if(signature, "Signature: " ++ format_detailed_cryptographic_signature(signature) ++ "\n"),
            "\n",
            indent("    ",
              if(description,
                format_commit_description_first_line(description.first_line()) ++
                  description.remove_prefix(description.first_line()).trim_end(),
                label(if(empty, "empty"), description_placeholder)) ++ "\n"),
            "\n",
          )
        '';
        log_bullet_oneline = ''
          concat(
            "- ",
            description.first_line(),
            "\n",
          )
        '';
        log_bullet = ''
          concat(
            "- ",
            description.first_line(),
            "\n",
            surround("\n", "\n",
              indent("  ",
                description.remove_prefix(description.first_line()).trim()))
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
        "megamerge()" = "heads(trunk()..@ & coalesce(merges(), empty() | description(exact:'')) ~ @)";
        "my_unmerged()" = "mine() ~ ::trunk()";
        "my_unmerged_remote()" = "mine() ~ ::trunk() & remote_bookmarks()";
        "not_pushed()" = "remote_bookmarks()..";
        "archived()" = "(mine() & description(regex:'^archive($|:)'))::";
        "unarchived(x)" = "x ~ archived()";
        "diverge(x)" = "fork_point(x)::x";
      };
      revsets = {
        log = "ancestors(unarchived(tree(@)), 2) | trunk()";
        fix = "unarchived(tree(@))";
        simplify-parents = "unarchived(tree(@))";
        short-prefixes = "~ ::trunk()";
      };
      aliases = {
        add-parent = [
          "util"
          "exec"
          "--"
          "${pkgs.writeShellScriptBin "jj-add-parent" ''
            ${config.programs.jujutsu.package}/bin/jj rebase -s $1 -d "$1-" -d $2
          ''}/bin/jj-add-parent"
        ];
        remove-parent = [
          "util"
          "exec"
          "--"
          "${pkgs.writeShellScriptBin "jj-remove-parent" ''
            ${config.programs.jujutsu.package}/bin/jj rebase -s $1 -d "$1- ~ $2"
          ''}/bin/jj-remove-parent"
        ];
        toggle-parent = [
          "util"
          "exec"
          "--"
          "${pkgs.writeShellScriptBin "jj-toggle-parent" ''
            ${config.programs.jujutsu.package}/bin/jj rebase -s $1 -d "($1- | $2) ~ ($1- & $2)"
          ''}/bin/jj-remove-parent"
        ];
        abandon- = ["abandon" "@-"];
        absorb- = ["absorb" "-f" "@-"];
        aliases = ["config" "list" "--include-defaults" "aliases"];
        annotate = ["file" "annotate" "-T" "annotate_header"];
        annotated = ["file" "annotate"];
        bl = ["bookmark" "list"];
        bump = ["metaedit" "--update-author" "--update-author-timestamp"];
        bump- = ["metaedit" "--update-author" "--update-author-timestamp" "@-"];
        bumpt = ["metaedit" "--update-author" "--update-author-timestamp" "tree(@)"];
        conflicts = ["resolve" "--list"];
        d = ["diff"];
        d- = ["diff" "-r" "@-"];
        dg = ["diff" "--tool" "idea"];
        dg- = ["diff" "--tool" "idea" "-r" "@-"];
        dd = ["diff" "--git" "--config=ui.pager='delta'"];
        dd- = ["diff" "--git" "--config=ui.pager='delta'" "-r" "@-"];
        ddl = ["diff" "--git" "--config=ui.pager='delta --line-numbers'"];
        ddl- = ["diff" "--git" "--config=ui.pager='delta --line-numbers'" "-r" "@-"];
        dt = ["diff" "--tool" "difft"];
        dt- = ["diff" "--tool" "difft" "-r" "@-"];
        desc- = ["describe" "@-"];
        descd = ["describe" "--config=templates.draft_commit_description=draft_commit_description"];
        descd- = ["describe" "--config=templates.draft_commit_description=draft_commit_description" "@-"];
        desct = ["describe" "tree(@)"];
        diffg = ["diff" "--tool" "idea"];
        diffg- = ["diff" "--tool" "idea" "-r" "@-"];
        diffedit- = ["diffedit" "-r" "@-"];
        diffeditg = ["diffedit" "--tool" "idea"];
        diffeditg- = ["diffedit" "--tool" "idea" "-r" "@-"];
        duplicateb = ["duplicate" "-B" "@"];
        duplicatet = ["duplicate" "-d" "trunk()"];
        duplicatem = ["duplicate" "-A" "trunk()" "-B" "megamerge()"];
        edit- = ["edit" "@-"];
        g = ["git"];
        gf = ["git" "fetch"];
        gp = ["git" "push"];
        jj = [];
        l = ["log"];
        la = ["log" "-r" "::@"];
        lar = ["log" "-r" "ancestors(mutable() & archived(), 2)"];
        lall = ["log" "-r" "all()"];
        lo = ["log" "-r" "overview()"];
        lm = ["log" "-r" "ancestors(unarchived(mutable()), 2) | trunk()"];
        lmu = ["log" "-r" "ancestors(unarchived(my_unmerged()), 2) | trunk()"];
        lmur = ["log" "-r" "ancestors(unarchived(my_unmerged_remote()), 2) | trunk()"];
        lnp = ["log" "-r" "ancestors(unarchived(not_pushed()), 2) | trunk()"];
        ls = ["log" "-r" "ancestors(unarchived(stack(@)), 2) | trunk()"];
        ldetailed = ["log" "-T" "log_detailed" "--summary"];
        loneline = ["log" "-T" "log_oneline"];
        lp = ["log" "-T" "log_compact_no_summary" "--patch"];
        lpatch = ["log" "-T" "log_compact_no_summary" "--patch"];
        lsummary = ["log" "-T" "log_compact_no_summary" "--summary"];
        n = ["new"];
        n- = ["new" "@-"];
        newt = ["new" "trunk()"];
        new- = ["new" "@-"];
        s = ["show"];
        sg = ["show" "--tool" "idea"];
        sg- = ["show" "--tool" "idea" "@-"];
        sp = ["show" "@-"];
        s- = ["show" "@-"];
        showg = ["show" "--tool" "idea"];
        showg- = ["show" "--tool" "idea" "@-"];
        summary = ["show" "--summary"];
        summary- = ["show" "--summary" "@-"];
        split- = ["split" "-r" "@-"];
        splitb = ["split" "-B" "@"];
        splitm = ["split" "-A" "trunk()" "-B" "megamerge()"];
        sq = ["squash"];
        sq- = ["squash" "-r" "@-"];
        squash- = ["squash" "-r" "@-"];
        sync = ["rebase" "-s" "roots(trunk()..@) & mutable()" "-d" "trunk()" "--skip-emptied"];
        synct = ["rebase" "-s" "children(::trunk()) & mine() & mutable() ~ archived()" "-d" "trunk()" "--skip-emptied"];
        rebaseb = ["rebase" "-B" "@"];
        rebasem = ["rebase" "-A" "trunk()" "-B" "megamerge()"];
        rebaset = ["rebase" "-d" "trunk()"];
        revert- = ["revert" "-r" "@-"];
        revertb = ["revert" "-B" "@"];
        revertm = ["revert" "-A" "trunk()" "-B" "megamerge()"];
        revertt = ["revert" "-d" "trunk()"];
      };
      merge-tools = {
        idea = {
          program = idea;
          diff-args = ["diff" "$left" "$right"];
          edit-args = ["diff" "$left" "$right"];
          merge-args = ["merge" "$left" "$right" "$base" "$output"];
        };
      };
      fix.tools = {
        alejandra = {
          command = ["alejandra" "--quiet" "-"];
          patterns = ["glob:'**/*.nix'"];
        };
        gofmt = {
          command = ["gofmt"];
          patterns = ["glob:'**/*.go'"];
        };
        rustfmt = {
          command = ["rustfmt" "--emit" "stdout" "--edition" "2024"];
          patterns = ["glob:'**/*.rs'"];
        };
        prettier = {
          command = ["npx" "prettier" "--stdin-filepath=$path"];
          patterns = ["glob:'**/*.tsx'" "glob:'**/*.ts'" "glob:'**/*.jsx'" "glob:'**/*.js'" "glob:'**/*.css'" "glob:'**/*.html'"];
        };
      };
      colors = {
        # Change IDs.
        "change_id" = "magenta";
        "trunk change_id" = "cyan";
        "working_copy change_id" = "green";
        "immutable change_id" = "default";
        "conflicted change_id" = "red";
        "wip change_id" = "yellow";
        "mutable wip change_id" = "yellow";
        "hidden change_id" = "black";

        # Commit IDs.
        "commit_id" = "bright cyan";
        "commit_id prefix" = {bold = false;};
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

        "working_copy" = {bold = false;};

        "working_copy empty" = {
          fg = "green";
          bold = true;
        };
        "working_copy empty description placeholder" = "green";
        "working_copy description" = {
          fg = "green";
          bold = true;
        };
        "working_copy description placeholder" = "green";
        "working_copy wip description placeholder" = "green";
        "working_copy wip empty description" = "green";
        "working_copy wip empty description placeholder" = "green";
        "working_copy bookmark" = "green";
        "working_copy bookmarks" = "green";
        "working_copy local_bookmarks" = "green";
        "working_copy remote_bookmarks" = "green";

        "log root" = "bright yellow";

        "node" = {
          fg = "magenta";
          bold = true;
        };
        "node working_copy" = "green";
        "node immutable" = "default";
        "node conflict" = "red";
        "node wip" = "yellow";

        "elided" = "#888888";
        "node elided" = "#888888";
      };
    };
  };

  home.shellAliases.j = "${pkgs.jujutsu}/bin/jj";

  home.packages = with pkgs; [
    jjui
  ];
}
