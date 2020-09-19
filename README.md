# bnjmnt4n/dotfiles

This repository contains my dotfiles, including my [Nix OS][nixos] configuration. This is very much a work-in-progress, and will probably change drastically as I figure out a setup that suits me.

## Setup

```sh
$ git clone https://github.com/bnjmnt4n/dotfiles.git  # Clone the repository
$ ./sync.sh                                           # Copies files to ~
                                                      # Requires `rsync`
```

I'm currently running [Nix OS][nixos] with a [KDE desktop environment][kde], and using [Doom Emacs][doom-emacs] as my editor (accompanied by vim and Visual Studio Code occasionally).

## References and Inspiration

I've gotten inspiration, and in some cases drawn liberally from the following places:

- [@andywhite37's guide on dual-booting Windows and NixOS][andywhite37/dual-boot]
- @jethrokuan's [Nix OS configuration][jethrokuan/nix-config] and [dotfiles][jethrokuan/dots], especially for Emacs and Nix OS-related configurations
- [sync.sh](./sync.sh) was copied from [@mathiasbynens's dotfiles][mathiasbynens/dotfiles]

[nixos]: https://nixos.org/
[kde]: https://kde.org/
[doom-emacs]: https://github.com/hlissner/doom-emacs
[andywhite37/dual-boot]: https://github.com/andywhite37/nixos/blob/9a3c13be14d3de4104322bb09efbf74245acffbd/DUAL_BOOT_WINDOWS_GUIDE.md
[jethrokuan/nix-config]: https://github.com/jethrokuan/nix-config
[jethrokuan/dots]: https://github.com/jethrokuan/dotfiles
[mathiasbynens/dotfiles]: https://github.com/mathiasbynens/dotfiles
