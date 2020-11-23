{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    emacs-pgtk-nativecomp-overlay.url =
      "github:mjlbach/emacs-pgtk-nativecomp-overlay?rev=b517b806ff6313fec99eb42292b1ebabf047b473";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  {
    nixosConfigurations = {
      bnjmnt4n = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./overlays.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bnjmnt4n = import ./home.nix;
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
