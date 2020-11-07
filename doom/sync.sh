#!/usr/bin/env bash
# Based on https://github.com/mathiasbynens/dotfiles/blob/0cd43d175a25c0e13e1e06ab31ccfd9f0169cf73/bootstrap.sh.

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
    rsync --exclude "sync.sh" -avh --no-perms . ~/.config/doom;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    read -p "This may overwrite your existing Doom Emacs configuration. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
