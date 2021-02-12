{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:bnjmnt4n/home-manager/flake";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
    firefox-nightly = { url = "github:colemickens/flake-firefox-nightly"; };
    firefox-nightly.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland?rev=f0fd29ba034c207dfe385b1565b020ec4446e9b8";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    overlays = [
      inputs.emacs-overlay.overlay
      inputs.neovim-nightly-overlay.overlay
      inputs.nixpkgs-wayland.overlay
      inputs.nur.overlay
      (final: prev: {
        naersk = inputs.naersk.lib.${system};
        firefox-nightly = inputs.firefox-nightly.packages.${system}.firefox-nightly-bin;
      })
      (import ./pkgs/default.nix)
    ];
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = {
      gastropod = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ ... }: {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
            nix.registry.nixpkgs.flake = nixpkgs;
            # Use our custom instance of nixpkgs with overlays and `allowUnfree`.
            nixpkgs = { inherit pkgs; };
          })
          ./hosts/gastropod/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bnjmnt4n = import ./hosts/gastropod/bnjmnt4n.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      bnjmnt4n = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "bnjmnt4n";
        homeDirectory = "/home/bnjmnt4n";
        configuration = ./hosts/gastropod/bnjmnt4n.nix;
      };
    };
  };
}
