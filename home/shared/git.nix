{
  pkgs,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin
      then pkgs.git
      else pkgs.gitFull;
    userName = "Benjamin Tan";
    userEmail = "benjamin@dev.ofcr.se";
    lfs.enable = true;

    signing = {
      key = config.programs.gpg.settings.default-key;
      signByDefault = config.programs.gpg.enable;
    };

    ignores = [
      ".DS_Store"
      ".jj"
      "*~"
      "*.swp"
    ];

    # Based on https://github.com/mathiasbynens/dotfiles/blob/0cd43d175a25c0e13e1e06ab31ccfd9f0169cf73/.gitconfig.
    aliases = {
      # View abbreviated SHA, description, and history graph of the latest 20 commits.
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";

      # View the current working tree status using the short format.
      s = "status -s";

      # Show the diff between the latest commit and the current state.
      d = "!git diff-index --quiet HEAD -- || clear; git diff --patch-with-stat";

      # `git di $number` shows the diff between the state `$number` revisions ago and the current state.
      di = "!d() { git diff --patch-with-stat HEAD~$1; }; git diff-index --quiet HEAD -- || clear; d";

      # Pull in remote changes for the current repository and all its submodules.
      pl = "pull --recurse-submodules";

      # Clone a repository including all submodules.
      c = "clone --recursive";

      # Fetch remote.
      f = "fetch --prune";

      # Show verbose output about tags, branches or remotes.
      tags = "tag -l";
      branches = "branch --all";
      remotes = "remote --verbose";

      # List aliases.
      aliases = "config --get-regexp alias";

      # Push.
      p = "push";
      fp = "push --force-with-lease";

      # Blame, following history across renames.
      bl = "blame -w -C -C -C";

      # Commit.
      co = "commit";
      com = "commit -m";
      coa = "!git add -A && git commit -av";

      # Amend commit.
      ca = "commit --amend";
      can = "commit --amend --no-edit";
      car = "commit --amend --reset-author";
      carn = "commit --amend --reset-author --no-edit";

      # Switch to a branch.
      go = "checkout";
      gonew = "checkout -b";
      br = "branch";

      # Stash.
      z = "stash";
      zz = "stash list";

      # Credit an author on the latest commit.
      credit = ''!f() { git commit --amend --author "$1 <$2>" -C HEAD; }; f'';

      reb = "rebase -i origin/HEAD --autosquash";
      # Interactive rebase with the given number of latest commits.
      rebn = "!r() { git rebase -i HEAD~$1 --autosquash; }; r";

      # Remove the old tag with this name and tag the latest commit with it.
      retag = "!r() { git tag -d $1 && git push origin :refs/tags/$1 && git tag $1; }; r";

      # List contributors with number of commits.
      contributors = "shortlog --summary --numbered";

      # Show the user email for the current repository.
      whoami = "config user.email";

      # Difftastic.
      dft = "!f() { GIT_EXTERNAL_DIFF=${pkgs.difftastic}/bin/difft git diff $@; }; f";
      dfts = "!f() { GIT_EXTERNAL_DIFF=${pkgs.difftastic}/bin/difft git show $@; }; f";
      dftl = "!f() { GIT_EXTERNAL_DIFF=${pkgs.difftastic}/bin/difft git log -p --ext-diff $@; }; f";
    };

    extraConfig = {
      init.defaultBranch = "main";
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      pull.rebase = "interactive";
      rebase = {
        updateRefs = true;
        autoSquash = true;
        autoStash = true;
      };
      rerere.enabled = true;
      diff.algorithm = "histogram";
      merge.conflictStyle = "zdiff3";

      fetch = {
        prune = true;
        pruneTags = true;
      };
      branch.sort = "-committerdate";
      tag.sort = "-taggerdate";
      transfer.fsckObjects = true;
    };
  };

  programs.gh.enable = true;

  # Shell aliases.
  home.shellAliases = {
    g = "git";

    ga = "git a";
    gc = "git c";
    gf = "git f";
    gp = "git p";
    gfp = "git fp";
    gpl = "git pl";
    gs = "git s";
    gz = "git z";
    gzz = "git zz";
    gl = "git l";

    gco = "git co";
    gcom = "git com";
    gcoa = "git coa";
    gam = "git amend";
    gca = "git ca";
    gcan = "git can";
    gcar = "git car";
    gcarn = "git carn";
    greb = "git reb";
    ggo = "git go";
    ggn = "git gonew";
    gbr = "git br";
    gsh = "git show";
  };

  programs.git.delta = {
    enable = true;
    options = {
      syntax-theme = "GitHub";
    };
  };
}
