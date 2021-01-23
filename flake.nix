{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-firefox.url = "github:nixos/nixpkgs?rev=d105075a1fd870b1d1617a6008cb38b443e65433";
    firefox-nightly = { url = "github:colemickens/flake-firefox-nightly"; };
    firefox-nightly.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland?rev=f0fd29ba034c207dfe385b1565b020ec4446e9b8";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  {
    nixosConfigurations = {
      gastropod = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            _module.args.inputs = inputs;
            _module.args.system = "x86_64-linux";
          })
          ./modules/overlays/default.nix
          ./hosts/gastropod/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bnjmnt4n = import ./hosts/gastropod/home.nix;
          }
        ];
      };
    };
  };
}
