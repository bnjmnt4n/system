{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    emacs-pgtk-nativecomp-overlay.url =
      "github:mjlbach/emacs-pgtk-nativecomp-overlay?rev=b517b806ff6313fec99eb42292b1ebabf047b473";
    emacs-pgtk-nativecomp-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { nixpkgs, nixpkgs-wayland, home-manager, emacs-pgtk-nativecomp-overlay, ... }:
  {
    nixosConfigurations = {
      bnjmnt4n = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              emacs-pgtk-nativecomp-overlay.overlay
              nixpkgs-wayland.overlay
            ];
          })
          ./overlays.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bnjmnt4n = import ./home.nix;
          }
        ];
      };
    };
  };
}
