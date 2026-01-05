{
  description = "bnjmnt4n's system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
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
    gh-pr-versions = {
      url = "github:bnjmnt4n/gh-pr-versions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    lib = import ./lib.nix inputs;
    forEach = list: f: builtins.foldl' (acc: item: nixpkgs.lib.recursiveUpdate acc (f item)) {} list;
    systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];
    templates = ["default" "go" "mariadb" "postgresql" "python" "web"];
  in
    lib.makeHostsConfigurations {
      macbook = {
        system = "aarch64-darwin";
        users = ["bnjmnt4n"];
      };
    }
    // forEach templates (name: {
      templates.${name} = {
        path = ./templates + "/${name}";
        description = name;
      };
    })
    // forEach systems (
      system: let
        pkgs = lib.makePkgs system;
      in {
        # Custom version of nixpkgs with overlays.
        # packages.${system}.nixpkgs = pkgs;
        devShells.${system}.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            scripts.switchHome
            scripts.switchNixos
            agenix
            stylua
            lua-language-server
          ];
        };
        formatter.${system} = pkgs.alejandra;
      }
    );
}
