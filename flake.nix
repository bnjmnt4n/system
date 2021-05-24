{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      overlays = [
        inputs.nixpkgs-wayland.overlay
        inputs.emacs-overlay.overlay
        inputs.neovim-nightly-overlay.overlay
        inputs.nur.overlay
        (import ./pkgs/default.nix)
      ];
      makePkgs = system: import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      makeNixosConfiguration = { system, modules }:
        let
          pkgs = makePkgs system;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModules.home-manager
            {
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
              # TODO: https://github.com/NixOS/nixpkgs/issues/124215
              nix.sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];
              nix.registry.nixpkgs.flake = nixpkgs;
              # Use our custom instance of nixpkgs.
              nixpkgs = {
                inherit pkgs; 
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ] ++ modules;
        };
      makeHomeManagerConfiguration = { system, username, configuration }:
        home-manager.lib.homeManagerConfiguration {
          inherit system username configuration;
          pkgs = makePkgs system;
          homeDirectory = "/home/${username}";
        };
    in
    {
      nixosConfigurations.gastropod = makeNixosConfiguration {
        system = "x86_64-linux";
        modules = [
          ./hosts/gastropod/configuration.nix
          # TODO: abstract home-manager user handling.
          {
            home-manager.users.bnjmnt4n = import ./hosts/gastropod/bnjmnt4n.nix;
          }
        ];
      };

      homeConfigurations.bnjmnt4n = makeHomeManagerConfiguration {
        system = "x86_64-linux";
        username = "bnjmnt4n";
        configuration = ./hosts/gastropod/bnjmnt4n.nix;
      };

      # Convenient shortcuts to switch configurations within this repository.
      devShell =
        let
          system = "x86_64-linux"; # Default solely to x86_64-linux for now.
          pkgs = makePkgs system;
          scripts = import ./lib/scripts.nix { inherit pkgs; };
        in
        {
          "${system}" = pkgs.mkShell {
            nativeBuildInputs = with scripts; [
              switchHome
              switchNixos
              pkgs.sumneko-lua-language-server
            ];
          };
        };
    };
}
