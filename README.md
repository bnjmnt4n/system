# bnjmnt4n/system

This repository contains configuration files for my systems, written largely in [Nix][nixos].

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

## Inspiration

I've gotten inspiration, and in some cases drawn liberally from the following places:

- [@andywhite37's guide on dual-booting Windows and NixOS][andywhite37/dual-boot]
- [@jethrokuan's][jethrokuan] [NixOS configuration][jethrokuan/nix-config] and [dotfiles][jethrokuan/dots]
- [@mathiasbynens's dotfiles][mathiasbynens/dotfiles]
- [@k-vernooy's dotfiles][k-vernooy/dotfiles]
- [@bqv's NixOS configuration][bqv/nixrc]
- [@thefloweringash's kevin-nix configuration][thefloweringash/kevin-nix]
- [@grahamc's NixOS configuration][grahamc/nixos-config]

[nixos]: https://nixos.org/
[swaywm]: https://swaywm.org/
[neovim]: https://neovim.io/
[andywhite37/dual-boot]: https://github.com/andywhite37/nixos/blob/9a3c13be14d3de4104322bb09efbf74245acffbd/DUAL_BOOT_WINDOWS_GUIDE.md
[jethrokuan]: https://github.com/jethrokuan
[jethrokuan/nix-config]: https://github.com/jethrokuan/nix-config
[jethrokuan/dots]: https://github.com/jethrokuan/dots
[mathiasbynens/dotfiles]: https://github.com/mathiasbynens/dotfiles
[k-vernooy/dotfiles]: https://github.com/k-vernooy/dotfiles
[bqv/nixrc]: https://github.com/bqv/nixrc
[thefloweringash/kevin-nix]: https://github.com/thefloweringash/kevin-nix
[grahamc/nixos-config]: https://github.com/grahamc/nixos-config
