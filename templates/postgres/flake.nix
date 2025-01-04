{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
    forEachSystem = systems: f: builtins.foldl' (acc: system: nixpkgs.lib.recursiveUpdate acc (f system)) {} systems;
  in
    forEachSystem systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      startPostgresqlScript = pkgs.writeShellScriptBin "start-postgresql" ''
        pg_ctl start -l $LOG_PATH -o "-c listen_addresses= -c unix_socket_directories=$PGHOST"
      '';
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (postgresql_16.withPackages (ps: [
            ps.pgjwt
          ]))
          startPostgresqlScript
        ];

        # Initialize a local PostgreSQL instance.
        # Based on https://gist.github.com/sebastian-stephan/d2013204e62070e5a56bc4f5415559a2.
        shellHook = ''
          export PGDATA=$PWD/postgres_data
          export PGHOST=$PWD/postgres
          export LOG_PATH=$PWD/postgres/LOG
          export PGDATABASE=postgres
          export DATABASE_URL="postgresql:///postgres?host=$PGHOST"
          if [ ! -d $PGHOST ]; then
            mkdir -p $PGHOST
          fi
          if [ ! -d $PGDATA ]; then
            echo 'Initializing postgresql database...'
            initdb $PGDATA --auth=trust >/dev/null
          fi
        '';
      };
    });
}
