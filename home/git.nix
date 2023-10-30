{ config, pkgs, ... }:

{
  # Version control for dummies.
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Benjamin Tan";
    userEmail = "benjamin@dev.ofcr.se";
    lfs.enable = true;

    signing = {
      key = "A853F0716C413825";
      signByDefault = true;
    };

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
      p = "pull --recurse-submodules";

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

      # Commit.
      co = "commit";
      com = "commit -m";
      coa = "!git add -A && git commit -av";

      # Amend commit.
      amend = "commit --amend --reuse-message=HEAD";
      ca = "commit --amend";
      can = "commit --amend --no-edit";
      car = "commit --amend --reset-author";
      carn = "commit --amend --reset-author --no-edit";

      # Switch to a branch.
      go = "checkout";
      gonew = "checkout -b";

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
    };

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;

      "url \"git@github.com:\"" = {
        insteadOf = "gh:";
      };
      "url \"git@gist.github.com:\"" = {
        insteadOf = "gist:";
      };
    };
  };

  programs.gh.enable = true;
  home.packages = [
    pkgs.gh
    pkgs.git-branchless
    pkgs.lazygit
  ];

  # Shell aliases.
  programs.fish.shellAliases.g = "git";
  programs.bash.shellAliases.g = "git";
}
