{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-staging.url = "github:NixOS/nixpkgs/staging";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    lazy-nvim = {
      url = "github:folke/lazy.nvim/stable";
      flake = false;
    };
    telescope-fzf-native = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
    canvas-downloader = {
      url = "github:k-walter/canvas-downloader";
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
  };

  outputs = { self, nixpkgs, flake-utils, agenix, nixos-hardware, home-manager, ... }@inputs:
    let
      makeOverlays = system: [
        inputs.agenix.overlays.default
        inputs.neovim-nightly-overlay.overlay
        inputs.nur.overlay
        inputs.tree-grepper.overlay."${system}"
        (import ./pkgs/default.nix inputs system)
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
        let
          pkgs = makePkgs system;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              nixpkgs = {
                overlays = makeOverlays system;
                config.allowUnfree = true;
              };
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
            }
            configuration
          ];
          extraSpecialArgs = { inherit inputs; };
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

      defaultTemplate = { path = ./templates/default; description = "Default"; };
      templates = {
        default = { path = ./templates/default; description = "Default"; };
        go = { path = ./templates/go; description = "Go"; };
        mariadb = { path = ./templates/mariadb; description = "MariaDB"; };
        ocaml = { path = ./templates/ocaml; description = "OCaml"; };
        postgres = { path = ./templates/postgres; description = "PostgreSQL"; };
        python = { path = ./templates/python; description = "Python"; };
        rust = { path = ./templates/rust; description = "Rust"; };
        web = { path = ./templates/web; description = "Web"; };
        zig = { path = ./templates/zig; description = "Zig"; };
      };
    }
    //
    # Convenient shortcuts to switch configurations within this repository.
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = makePkgs system;
        scripts = import ./lib/scripts.nix { inherit pkgs inputs; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            scripts.switchHome
            scripts.switchNixos
            pkgs.agenix
            pkgs.stylua
            pkgs.sumneko-lua-language-server
          ];
        };
      }
    );
}
