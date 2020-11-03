{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    emacs-pgtk = {
      url = "github:mjlbach/emacs-pgtk-nativecomp-overlay?rev=b517b806ff6313fec99eb42292b1ebabf047b473";
      inputs = {
        nixpkgs = { follows = "nixpkgs"; };
      };
    };
  };

  outputs = inputs:
  {
    nixosConfigurations = {
      bnjmnt4n = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ inputs.emacs-pgtk.overlay ];
          })
          ./configuration.nix
        ];
      };
    };
  };
}
