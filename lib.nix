{
  self,
  nixpkgs,
  home-manager,
  nix-darwin,
  ...
} @ inputs: let
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  nixosStateVersion = "20.03";
  darwinStateVersion = 4;
  homeStateVersion = "26.05";
in rec {
  overlays = [
    inputs.agenix.overlays.default
    inputs.nur.overlays.default
    inputs.jujutsu.overlays.default
    (import ./pkgs inputs)
  ];

  makePkgs = system:
    import nixpkgs {
      inherit system overlays;
      config = import ./home/shared/nix/nixpkgs-config.nix;
    };

  makeHostsConfigurations = hosts:
    nixpkgs.lib.foldl'
    (attrs: hostname: let
      inherit (hosts.${hostname}) system users;
      isDarwin = nixpkgs.lib.hasSuffix "-darwin" system;
      pkgs = makePkgs system;
    in (nixpkgs.lib.foldl' nixpkgs.lib.recursiveUpdate attrs [
      (
        if isDarwin
        then {
          darwinConfigurations.${hostname} = makeDarwinConfiguration {
            inherit pkgs hostname users;
            modules = hosts.${hostname}.darwinModules or [];
            primaryUser = hosts.${hostname}.primaryUser;
          };
        }
        else {
          nixosConfigurations.${hostname} = makeNixosConfiguration {
            inherit pkgs hostname users;
            modules = hosts.${hostname}.nixosModules or [];
          };
        }
      )
      (nixpkgs.lib.foldl'
        (attrs: username:
          nixpkgs.lib.recursiveUpdate attrs {
            homeConfigurations."${username}@${hostname}" = makeHomeManagerConfiguration {
              inherit pkgs hostname username;
              modules = users.${username};
            };
          })
        {}
        (builtins.attrNames users))
    ]))
    {}
    (builtins.attrNames hosts);

  makeNixosConfiguration = {
    pkgs,
    hostname,
    modules ? [],
    users,
  }:
    nixpkgs.lib.nixosSystem {
      modules =
        [
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.age
          inputs.nix-index-database.nixosModules.nix-index
          {
            system.stateVersion = nixosStateVersion;
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.nixPath = ["nixpkgs=${nixpkgs}"];
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.my.flake = self;
            # Use our custom instance of nixpkgs.
            nixpkgs.pkgs = pkgs;
            nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            networking.hostName = hostname;
          }
          (./hosts + "/${hostname}/configuration.nix")
          (nixpkgs.lib.foldl'
            (attrs: username:
              nixpkgs.lib.recursiveUpdate attrs {
                home-manager.users.${username} = args: {
                  imports =
                    [
                      inputs.agenix.homeManagerModules.default
                      (./hosts + "/${hostname}/${username}.nix")
                    ]
                    ++ users.${username};

                  home = {
                    inherit username;
                    homeDirectory = "/home/${username}";
                    stateVersion = homeStateVersion;
                  };
                };
              })
            {}
            (builtins.attrNames users))
        ]
        ++ modules;
    };

  makeDarwinConfiguration = {
    pkgs,
    hostname,
    modules ? [],
    users,
    primaryUser,
  }:
    nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules =
        [
          home-manager.darwinModules.home-manager
          inputs.nix-index-database.darwinModules.nix-index
          {
            system.stateVersion = darwinStateVersion;
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.nixPath = ["nixpkgs=${nixpkgs}"];
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.my.flake = self;
            # Use our custom instance of nixpkgs.
            nixpkgs.pkgs = pkgs;
            nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            networking.hostName = hostname;
            system.primaryUser = primaryUser;
          }
          (./hosts + "/${hostname}/configuration.nix")
          (nixpkgs.lib.foldl'
            (attrs: username:
              nixpkgs.lib.recursiveUpdate attrs {
                users.users.${username} = {
                  home = "/Users/${username}";
                  shell = "/run/current-system/sw/bin/fish";
                };
                home-manager.users.${username} = args: {
                  imports =
                    [
                      inputs.agenix.homeManagerModules.default
                      (./hosts + "/${hostname}/${username}.nix")
                    ]
                    ++ users.${username};

                  home = {
                    inherit username;
                    homeDirectory = "/Users/${username}";
                    stateVersion = homeStateVersion;
                  };
                };
              })
            {}
            (builtins.attrNames users))
        ]
        ++ modules;
    };

  makeHomeManagerConfiguration = {
    pkgs,
    hostname,
    username,
    modules ? [],
  }:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules =
        [
          inputs.nix-index-database.homeModules.nix-index
          inputs.agenix.homeManagerModules.default
          {
            nixpkgs = {
              inherit overlays;
              config = import ./home/shared/nix/nixpkgs-config.nix;
            };
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.my.flake = self;
            home = {
              inherit username;
              homeDirectory =
                if pkgs.stdenv.hostPlatform.isDarwin
                then "/Users/${username}"
                else "/home/${username}";
              stateVersion = homeStateVersion;
            };
            programs.home-manager.enable = true;
          }
          (./hosts + "/${hostname}/${username}.nix")
        ]
        ++ modules;
    };
}
