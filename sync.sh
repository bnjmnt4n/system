#!/usr/bin/env bash
# Based on https://github.com/mathiasbynens/dotfiles/blob/0cd43d175a25c0e13e1e06ab31ccfd9f0169cf73/bootstrap.sh.

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
    rsync --exclude ".git/" \
        --exclude "sync.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
