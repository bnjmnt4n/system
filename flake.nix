{
  description = "bnjmnt4n's system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
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
  };

  outputs = { self, flake-utils, nixos-hardware, ... }@inputs:
    let
      utils = import ./lib/utils.nix inputs;
    in
    {
      nixosConfigurations = {
        gastropod = utils.makeNixosConfiguration {
          system = "x86_64-linux";
          hostname = "gastropod";
          users = [ "bnjmnt4n" ];
        };
        raspy = utils.makeNixosConfiguration {
          system = "aarch64-linux";
          hostname = "raspy";
          users = [ "bnjmnt4n" "guest" ];
          modules = [ nixos-hardware.nixosModules.raspberry-pi-4 ];
        };
      };

      darwinConfigurations.macbook = utils.makeDarwinConfiguration {
        system = "aarch64-darwin";
        hostname = "macbook";
        users = [ "bnjmnt4n" ];
      };

      homeConfigurations = {
        "bnjmnt4n@gastropod" = utils.makeHomeManagerConfiguration {
          system = "x86_64-linux";
          hostname = "gastropod";
          username = "bnjmnt4n";
        };
        "bnjmnt4n@macbook" = utils.makeHomeManagerConfiguration {
          system = "aarch64-darwin";
          hostname = "macbook";
          username = "bnjmnt4n";
        };
        "bnjmnt4n@windows" = utils.makeHomeManagerConfiguration {
          system = "x86_64-linux";
          hostname = "windows";
          username = "bnjmnt4n";
        };
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
        pkgs = utils.makePkgs system;
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
