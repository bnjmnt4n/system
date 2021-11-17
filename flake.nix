{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    telescope-fzf-native = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
    fluminurs = {
      url = "github:bnjmnt4n/fluminurs";
      flake = false;
    };
    socprint = {
      url = "github:dlqs/SOCprint";
      flake = false;
    };
    tree-grepper = {
      url = "github:BrianHicks/tree-grepper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, flake-utils, agenix, nixos-hardware, home-manager, ... }@inputs:
    let
      makeOverlays = system: [
        inputs.agenix.overlay
        inputs.emacs-overlay.overlay
        inputs.neovim-nightly-overlay.overlay
        inputs.nur.overlay
        inputs.tree-grepper.overlay."${system}"
        (import ./pkgs/default.nix inputs)
      ];
      makePkgs = system: import nixpkgs {
        inherit system;
        overlays = makeOverlays system;
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
            agenix.nixosModules.age
            {
              # Before changing this value read the documentation for this option
              # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
              system.stateVersion = "20.03";
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
              nix.registry.nixpkgs.flake = nixpkgs;
              # Use our custom instance of nixpkgs.
              nixpkgs = { inherit pkgs; };
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

      nixosConfigurations.raspy = makeNixosConfiguration {
        system = "aarch64-linux";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/raspy/configuration.nix
          # TODO: abstract home-manager user handling.
          {
            home-manager.users.bnjmnt4n = import ./hosts/raspy/bnjmnt4n.nix;
            home-manager.users.guest = import ./hosts/raspy/guest.nix;
          }
        ];
      };

      homeConfigurations.bnjmnt4n = makeHomeManagerConfiguration {
        system = "x86_64-linux";
        username = "bnjmnt4n";
        configuration = ./hosts/gastropod/bnjmnt4n.nix;
      };

      homeConfigurations.wsl = makeHomeManagerConfiguration {
        system = "x86_64-linux";
        username = "bnjmnt4n";
        configuration = ./hosts/wsl/bnjmnt4n.nix;
      };
    }
    //
    # Convenient shortcuts to switch configurations within this repository.
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = makePkgs system;
        scripts = import ./lib/scripts.nix { inherit pkgs; };
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with scripts; [
            switchHome
            switchNixos
            pkgs.agenix
            pkgs.nixpkgs-fmt
            pkgs.rnix-lsp
            pkgs.stylua
            pkgs.sumneko-lua-language-server
          ];
        };
      }
    );
}
