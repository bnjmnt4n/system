{ self, nixpkgs, agenix, home-manager, ... }@inputs:

rec {
  makeOverlays = system: [
    inputs.agenix.overlays.default
    inputs.neovim-nightly-overlay.overlay
    inputs.nur.overlay
    inputs.tree-grepper.overlay."${system}"
    (import ../pkgs/default.nix inputs system)
  ];

  makePkgs = system: import nixpkgs {
    inherit system;
    overlays = makeOverlays system;
    config.allowUnfree = true;
  };

  makeNixosConfiguration = { system, hostname, username, modules, users }:
    let
      pkgs = makePkgs system;
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = modules ++ [
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
        (../hosts + "/${hostname}/configuration.nix")
      ] ++ nixpkgs.lib.lists.singleton nixpkgs.lib.attrsets.genAttrs users (user: {
        home-manager.users."${user}" = {
          home = {
            username = user;
            homeDirectory = "/home/${user}";
            stateVersion = "20.09";
          };
        } // import (../hosts + "/${hostname}/${user}.nix");
      });
    };

  makeHomeManagerConfiguration = { system, hostname, username }:
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
            stateVersion = "20.09";
          };
          programs.home-manager.enable = true;
        }
        (../hosts + "/${hostname}/${username}.nix")
      ];
      extraSpecialArgs = { inherit inputs; };
    };
}
