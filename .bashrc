export PATH="$HOME/.emacs.d/bin:$PATH"

# Fast Rust-powered shell prompt.
# https://starship.rs/
eval "$(starship init bash)"

# direnv
eval "$(direnv hook bash)"
