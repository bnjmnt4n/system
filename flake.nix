{
  description = "bnjmnt4n's system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin = {
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
    mac-app-util.url = "github:hraban/mac-app-util";
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
    jujutsu.url = "github:jj-vcs/jj";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      lib = import ./lib.nix inputs;
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
      forEachSystem = systems: f: builtins.foldl' (acc: system: nixpkgs.lib.recursiveUpdate acc (f system)) {} systems;
    in
    lib.makeHostsConfigurations {
      macbook = {
        system = "aarch64-darwin";
        users = [ "bnjmnt4n" ];
      };
      windows = {
        system = "x86_64-linux";
        users = [ "bnjmnt4n" ];
      };
      raspy = {
        system = "aarch64-linux";
        users = [ "bnjmnt4n" "guest" ];
        nixosModules = [ inputs.nixos-hardware.nixosModules.raspberry-pi-4 ];
      };
    }
    //
    {
      templates = {
        default = { path = ./templates/default; description = "Default"; };
        go = { path = ./templates/go; description = "Go"; };
        mariadb = { path = ./templates/mariadb; description = "MariaDB"; };
        postgres = { path = ./templates/postgres; description = "PostgreSQL"; };
        python = { path = ./templates/python; description = "Python"; };
        web = { path = ./templates/web; description = "Web"; };
      };
    }
    //
    forEachSystem systems (system:
      let
        pkgs = lib.makePkgs system;
      in
      {
        # Custom version of nixpkgs with overlays.
        packages.${system}.nixpkgs = pkgs;
        devShells.${system}.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            scripts.switchHome
            scripts.switchNixos
            agenix
            stylua
            sumneko-lua-language-server
          ];
        };
      }
    );
}
