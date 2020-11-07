#!/usr/bin/env bash

cd ~
xdg-open "$(fd . Desktop Documents Downloads Dropbox \
    -E "!{*.srt,*.rar,*.txt,*.zip,*.nfo}" | \
    wofi --dmenu)"
