# Clear greeting.
set fish_greeting

# Include doom in PATH.
set PATH $PATH $HOME/.emacs.d/bin

# Fast Rust-powered shell prompt.
# https://starship.rs/
eval (starship init fish)

# direnv integration.
eval (direnv hook fish)
