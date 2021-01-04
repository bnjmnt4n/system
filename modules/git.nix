{ pkgs, ... }:

{
  # Version control for dummies.
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Benjamin Tan";
    userEmail = "benjamin@dev.ofcr.se";
    delta.enable = true;
    lfs.enable = true;

    # Based on https://github.com/mathiasbynens/dotfiles/blob/0cd43d175a25c0e13e1e06ab31ccfd9f0169cf73/.gitconfig.
    aliases = {
      # View abbreviated SHA, description, and history graph of the latest 20 commits.
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";

      # View the current working tree status using the short format.
      s = "status -s";

      # Show the diff between the latest commit and the current state.
      d = "!git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat";

      # `git di $number` shows the diff between the state `$number` revisions ago and the current state.
      di = "!d() { git diff --patch-with-stat HEAD~$1; }; git diff-index --quiet HEAD -- || clear; d";

      # Pull in remote changes for the current repository and all its submodules.
      p = "pull --recurse-submodules";

      # Clone a repository including all submodules.
      c = "clone --recursive";

      # Show verbose output about tags, branches or remotes
      tags = "tag -l";
      branches = "branch --all";
      remotes = "remote --verbose";

      # List aliases.
      aliases = "config --get-regexp alias";

      # Amend the currently staged files to the latest commit.
      amend = "commit --amend --reuse-message=HEAD";

      # Commit.
      co = "commit";

      # Commit with message.
      com = "commit -m";

      # Commit all changes.
      ca = "!git add -A && git commit -av";

      # Switch to a branch, creating it if necessary.
      go = "!f() { git checkout -b \"$1\" 2> /dev/null || git checkout \"$1\"; }; f";

      # Credit an author on the latest commit.
      credit = "!f() { git commit --amend --author \"$1 <$2>\" -C HEAD; }; f";

      # Interactive rebase with the given number of latest commits.
      reb = "!r() { git rebase -i HEAD~$1; }; r";

      # Remove the old tag with this name and tag the latest commit with it.
      retag = "!r() { git tag -d $1 && git push origin :refs/tags/$1 && git tag $1; }; r";

      # Remove branches that have already been merged with main.
      # a.k.a. ‘delete merged’
      dm = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";

      # List contributors with number of commits.
      contributors = "shortlog --summary --numbered";

      # Show the user email for the current repository.
      whoami = "config user.email";
    };
    extraConfig = {
      credential = {
        helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
      };
    };
  };

  programs.gh.enable = true;

  home.packages = with pkgs; [
    libsecret
  ];
}
