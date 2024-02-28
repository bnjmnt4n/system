# bnjmnt4n/system

This repository contains configuration files for my systems, written largely in [Nix](https://nixos.org/).

## Setup

A Nix installation with flakes support is required.

```sh
# Install Nix if not installed
$ sh <(curl -L https://nixos.org/nix/install) # Linux/Mac
$ sh <(curl -L https://nixos.org/nix/install) --daemon # WSL

# Setup Nix flakes support
$ mkdir -p ~/.config/nix
$ echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Clone the repository.
$ git clone https://github.com/bnjmnt4n/system.git
$ cd system

# Use local development shell
$ nix develop
$ swn # Switch to the new NixOS/nix-darwin configuration.
$ swh # Switch to the new home configuration.

# Update dependencies.
$ nix flake update

# Alternative commands:
# Switching NixOS configuration:
$ sudo nixos-rebuild switch --flake '.#$HOSTNAME'

# Switching nix-darwin configuration:
$ nix build '.#darwinConfigurations.$HOSTNAME_$USER.system'
$ ./result/sw/bin/darwin-rebuild switch --flake . '.#$HOSTNAME'

# Switching home-manager configuration:
$ nix build '.#homeConfigurations.$HOSTNAME_$USERNAME.activationPackage'
$ ./result/activate
```

## Other steps

MacOS:

1. Install the [standalone variant of Tailscale](https://tailscale.com/kb/1065/macos-variants).

Windows:

1. Install [AutoHotkey](https://www.autohotkey.com/).

## Inspiration

I've gotten inspiration, and in some cases drawn liberally from the following places:

- [@andywhite37's guide on dual-booting Windows and NixOS](https://github.com/andywhite37/nixos/blob/9a3c13be14d3de4104322bb09efbf74245acffbd/DUAL_BOOT_WINDOWS_GUIDE.md)
- [@jethrokuan's][jethrokuan] [NixOS configuration](https://github.com/jethrokuan/nix-config) and [dotfiles](https://github.com/jethrokuan/dots)
- [@mathiasbynens's dotfiles](https://github.com/mathiasbynens/dotfiles)
- [@k-vernooy's dotfiles](https://github.com/k-vernooy/dotfiles)
- [@bqv's NixOS configuration](https://github.com/bqv/nixrc)
- [@thefloweringash's kevin-nix configuration](https://github.com/thefloweringash/kevin-nix)
- [@grahamc's NixOS configuration](https://github.com/grahamc/nixos-config)
