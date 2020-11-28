{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
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
