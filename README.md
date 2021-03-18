# bnjmnt4n/system

This repository contains configuration files for my system, written largely in [Nix][nixos].

I'm currently running [NixOS][nixos] with [swaywm][swaywm], using [Doom Emacs][doom-emacs] as my editor.

## Setup

A Nix installation with flakes support is required.

```sh
# Clone the repository.
$ git clone https://github.com/bnjmnt4n/system.git
$ cd system

# Rebuilds my NixOS configuration.
$ sudo nixos-rebuild switch --flake '.#gastropod'

# Rebuilds my home-manager configuration.
$ nix build '.#homeConfigurations.bnjmnt4n.activationPackage'
$ ./result/activate

# Alternatively
$ nix develop
$ swn # Switch to the new NixOS configuration.
$ swh # Switch to the new home configuration.

# Sync Doom configuration to `$HOME/.config/doom`.
# Only needs to be done on first install.
ln -s doom ./.config/doom

# Update dependencies.
nix flake update
```

## Inspiration

I've gotten inspiration, and in some cases drawn liberally from the following places:

- [@andywhite37's guide on dual-booting Windows and NixOS][andywhite37/dual-boot]
- [@jethrokuan's][jethrokuan] [NixOS configuration][jethrokuan/nix-config] and [dotfiles][jethrokuan/dots]
- [@mathiasbynens's dotfiles][mathiasbynens/dotfiles]
- [@k-vernooy's dotfiles][k-vernooy/dotfiles]
- [@bqv's NixOS configuration][bqv/nixrc]
- [@thefloweringash's kevin-nix configuration][thefloweringash/kevin-nix]

[nixos]: https://nixos.org/
[swaywm]: https://swaywm.org/
[doom-emacs]: https://github.com/hlissner/doom-emacs
[andywhite37/dual-boot]: https://github.com/andywhite37/nixos/blob/9a3c13be14d3de4104322bb09efbf74245acffbd/DUAL_BOOT_WINDOWS_GUIDE.md
[jethrokuan]: https://github.com/jethrokuan
[jethrokuan/nix-config]: https://github.com/jethrokuan/nix-config
[jethrokuan/dots]: https://github.com/jethrokuan/dots
[mathiasbynens/dotfiles]: https://github.com/mathiasbynens/dotfiles
[k-vernooy/dotfiles]: https://github.com/k-vernooy/dotfiles
[bqv/nixrc]: https://github.com/bqv/nixrc
[thefloweringash/kevin-nix]: https://github.com/thefloweringash/kevin-nix/
