{
  description = "bnjmnt4n's system configurations";

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

  outputs = { self, flake-utils, nixos-hardware, ... }@inputs:
    let
      utils = import ./lib/utils.nix inputs;
    in
    {
      nixosConfigurations.gastropod = utils.makeNixosConfiguration {
        system = "x86_64-linux";
        hostname = "gastropod";
        users = [ "bnjmnt4n" ];
      };

      nixosConfigurations.raspy = utils.makeNixosConfiguration {
        system = "aarch64-linux";
        hostname = "raspy";
        users = [ "bnjmnt4n" ];
        modules = [nixos-hardware.nixosModules.raspberry-pi-4];
      };

      homeConfigurations.bnjmnt4n = utils.makeHomeManagerConfiguration {
        system = "x86_64-linux";
        hostname = "gastropod";
        username = "bnjmnt4n";
      };

      homeConfigurations.windows_bnjmnt4n = utils.makeHomeManagerConfiguration {
        system = "x86_64-linux";
        hostname = "windows";
        username = "bnjmnt4n";
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
