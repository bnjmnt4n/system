{ self, nixpkgs, agenix, home-manager, darwin, nix-index-database, mac-app-util, ... }@inputs:

let
  homeStateVersion = "20.09";
  optional = condition: item: if condition then [ item ] else [ ];
in
rec {
  makeOverlays = system: [
    inputs.agenix.overlays.default
    inputs.neovim-nightly-overlay.overlay
    inputs.nur.overlay
    inputs.jujutsu.overlays.default
    (import ../pkgs inputs system)
  ] ++ (optional (system == "aarch64-darwin") inputs.firefox-darwin.overlay);

  makePkgs = system: import nixpkgs {
    inherit system;
    overlays = makeOverlays system;
    config.allowUnfree = true;
  };

  makeNixosConfiguration = { system, hostname, username, modules ? [ ], users }:
    let
      pkgs = makePkgs system;
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = modules ++ [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.age
        nix-index-database.nixosModules.nix-index
        {
          # Before changing this value read the documentation for this option
          # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
          system.stateVersion = "20.03";
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.my.flake = self;
          # Use our custom instance of nixpkgs.
          nixpkgs = { inherit pkgs; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        (../hosts + "/${hostname}/configuration.nix")
        (nixpkgs.lib.lists.foldl'
          (attrs: user: attrs // {
            home-manager.users.${user} = args: {
              imports = [
                (../hosts + "/${hostname}/${user}.nix")
              ];

              home = {
                username = user;
                homeDirectory = "/home/${user}";
                stateVersion = homeStateVersion;
              };
            };
          })
          { }
          users)
      ];
    };

  makeDarwinConfiguration = { system, hostname, modules ? [ ], users }:
    let
      pkgs = makePkgs system;
    in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.darwinModules.home-manager
        nix-index-database.darwinModules.nix-index
        mac-app-util.darwinModules.default
        {
          # Before changing this value read the documentation for this option
          # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
          system.stateVersion = 4;
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
          nix.registry.my.flake = self;
          nix.registry.nixpkgs.flake = nixpkgs;
          # Use our custom instance of nixpkgs.
          nixpkgs = { inherit pkgs; };
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        (../hosts + "/${hostname}/configuration.nix")
        (nixpkgs.lib.lists.foldl'
          (attrs: user: attrs // {
            users.users."${user}" = {
              home = "/Users/${user}";
              shell = "/run/current-system/sw/bin/fish";
            };
            home-manager.users.${user} = args: {
              imports = [
                (../hosts + "/${hostname}/${user}.nix")
                agenix.homeManagerModules.default
                mac-app-util.homeManagerModules.default
              ];

              home = {
                username = user;
                homeDirectory = "/Users/${user}";
                stateVersion = homeStateVersion;
              };
            };
          })
          { }
          users)
      ];
    };

  makeHomeManagerConfiguration = { system, hostname, username }:
    let
      pkgs = makePkgs system;
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        nix-index-database.hmModules.nix-index
        agenix.homeManagerModules.default
        {
          nixpkgs = {
            overlays = makeOverlays system;
            config.allowUnfree = true;
          };
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.my.flake = self;
          home = {
            inherit username;
            homeDirectory = if system == "aarch64-darwin" then "/Users/${username}" else "/home/${username}";
            stateVersion = homeStateVersion;
          };
          programs.home-manager.enable = true;
        }
        (../hosts + "/${hostname}/${username}.nix")
      ];
      extraSpecialArgs = { inherit inputs; };
    };
}
