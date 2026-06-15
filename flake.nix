{
  description = "bnjmnt4n's system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazy-nvim = {
      url = "github:folke/lazy.nvim/stable";
      flake = false;
    };
    modus-themes = {
      url = "github:miikanissi/modus-themes.nvim";
      flake = false;
    };
    telescope-fzf-native = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
    tuicr = {
      url = "github:agavra/tuicr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jujutsu.url = "github:jj-vcs/jj";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    lib = import ./lib.nix inputs;
    forEach = list: f: builtins.foldl' (acc: item: nixpkgs.lib.recursiveUpdate acc (f item)) {} list;
    systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];
    templates = ["default" "go" "postgresql" "python" "web"];
  in
    lib.makeHostsConfigurations {
      veracity = {
        system = "aarch64-darwin";
        users = {
          "bnjmnt4n" = [];
        };
        primaryUser = "bnjmnt4n";
      };
    }
    // {
      inherit lib;
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
        packages.${system}.nixpkgs = pkgs;
        devShells.${system}.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            scripts.switchHome
            scripts.switchNixos
            agenix
            go
            gopls
            stylua
            lua-language-server
          ];
        };
        formatter.${system} = pkgs.alejandra;
      }
    );
}
