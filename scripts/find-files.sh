#!/usr/bin/env bash

cd ~
FILE="$(fd . Desktop Documents Downloads Dropbox \
    -E "!{*.srt,*.rar,*.txt,*.zip,*.nfo}" | \
    wofi --dmenu)"
xdg-open "$HOME/$FILE"
