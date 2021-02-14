# bnjmnt4n/home

This repository contains my home environment, largely consisting of my [NixOS][nixos] configuration. This is very much a work-in-progress, and will probably change drastically as I figure out a setup that suits me.

## Setup

```sh
# Clone the repository.
$ git clone https://github.com/bnjmnt4n/home.git
$ cd home

# Rebuilds my NixOS configuration.
$ sudo nixos-rebuild switch --flake '.#gastropod'
# Or `switchn`

# Rebuilds my home-manager configuration.
$ nix build '.#homeConfigurations.bnjmnt4n.activationPackage'
$ ./result/activate
# Or `switchh`

# Sync Doom configuration to `$HOME/config/doom`.
$ ./doom/sync.sh
```

I'm currently running [NixOS][nixos] with [swaywm][swaywm], using [Doom Emacs][doom-emacs] as my editor.

## References and Inspiration

I've gotten inspiration, and in some cases drawn liberally from the following places:

- [@andywhite37's guide on dual-booting Windows and NixOS][andywhite37/dual-boot]
- [@jethrokuan's][jethrokuan] [NixOS configuration][jethrokuan/nix-config] and [dotfiles][jethrokuan/dots], especially for Emacs and NixOS-related configurations
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
