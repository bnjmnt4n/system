{
  self,
  nixpkgs,
  home-manager,
  nix-darwin,
  ...
} @ inputs: let
  homeStateVersion = "20.09";
  mkIf = cond: attrs:
    if cond
    then attrs
    else {};
in rec {
  overlays = [
    inputs.agenix.overlays.default
    inputs.neovim-nightly-overlay.overlays.default
    inputs.nur.overlays.default
    inputs.jujutsu.overlays.default
    (import ./pkgs inputs)
  ];

  makePkgs = system:
    import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

  makeHostsConfigurations = hosts:
    nixpkgs.lib.foldl'
    (attrs: hostname: let
      inherit (hosts.${hostname}) system users;
      isDarwin = system == "aarch64-darwin";
    in (nixpkgs.lib.foldl' nixpkgs.lib.recursiveUpdate attrs [
      (mkIf (!isDarwin) {
        nixosConfigurations.${hostname} = makeNixosConfiguration {
          inherit system hostname users;
          modules = hosts.${hostname}.nixosModules or [];
        };
      })
      (mkIf isDarwin {
        darwinConfigurations.${hostname} = makeDarwinConfiguration {
          inherit system hostname users;
          modules = hosts.${hostname}.darwinModules or [];
        };
      })
      (nixpkgs.lib.foldl'
        (attrs: username:
          nixpkgs.lib.recursiveUpdate attrs {
            homeConfigurations."${username}@${hostname}" = makeHomeManagerConfiguration {
              inherit system hostname username;
            };
          })
        {}
        users)
    ]))
    {}
    (builtins.attrNames hosts);

  makeNixosConfiguration = {
    system,
    hostname,
    modules ? [],
    users,
  }: let
    pkgs = makePkgs system;
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        modules
        ++ [
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.age
          inputs.nix-index-database.nixosModules.nix-index
          {
            # Before changing this value read the documentation for this option
            # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
            system.stateVersion = "20.03";
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.nixPath = ["nixpkgs=${nixpkgs}"];
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;
            nix.registry.my.flake = self;
            # Use our custom instance of nixpkgs.
            nixpkgs = {inherit pkgs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          (./hosts + "/${hostname}/configuration.nix")
          (nixpkgs.lib.foldl'
            (attrs: user:
              nixpkgs.lib.recursiveUpdate attrs {
                home-manager.users.${user} = args: {
                  imports = [
                    (./hosts + "/${hostname}/${user}.nix")
                  ];

                  home = {
                    username = user;
                    homeDirectory = "/home/${user}";
                    stateVersion = homeStateVersion;
                  };
                };
              })
            {}
            users)
        ];
    };

  makeDarwinConfiguration = {
    system,
    hostname,
    modules ? [],
    users,
  }: let
    pkgs = makePkgs system;
  in
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules =
        modules
        ++ [
          home-manager.darwinModules.home-manager
          inputs.nix-index-database.darwinModules.nix-index
          inputs.mac-app-util.darwinModules.default
          {
            # Before changing this value read the documentation for this option
            # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
            system.stateVersion = 4;
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.nixPath = ["nixpkgs=${nixpkgs}"];
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;
            nix.registry.my.flake = self;
            # Use our custom instance of nixpkgs.
            nixpkgs = {inherit pkgs;};
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          (./hosts + "/${hostname}/configuration.nix")
          (nixpkgs.lib.foldl'
            (attrs: user:
              nixpkgs.lib.recursiveUpdate attrs {
                users.users.${user} = {
                  home = "/Users/${user}";
                  shell = "/run/current-system/sw/bin/fish";
                };
                home-manager.users.${user} = args: {
                  imports = [
                    (./hosts + "/${hostname}/${user}.nix")
                    inputs.agenix.homeManagerModules.default
                    inputs.mac-app-util.homeManagerModules.default
                  ];

                  home = {
                    username = user;
                    homeDirectory = "/Users/${user}";
                    stateVersion = homeStateVersion;
                  };
                };
              })
            {}
            users)
        ];
    };

  makeHomeManagerConfiguration = {
    system,
    hostname,
    username,
  }: let
    pkgs = makePkgs system;
  in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        inputs.nix-index-database.hmModules.nix-index
        inputs.agenix.homeManagerModules.default
        {
          nixpkgs = {
            inherit overlays;
            config.allowUnfree = true;
          };
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.nixpkgs-stable.flake = inputs.nixpkgs-stable;
          nix.registry.my.flake = self;
          home = {
            inherit username;
            homeDirectory =
              if system == "aarch64-darwin"
              then "/Users/${username}"
              else "/home/${username}";
            stateVersion = homeStateVersion;
          };
          programs.home-manager.enable = true;
        }
        (./hosts + "/${hostname}/${username}.nix")
      ];
      extraSpecialArgs = {inherit inputs;};
    };
}
