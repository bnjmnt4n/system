{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=04f574a1c0fde90b51bf68198e2297ca4e7cccf4";
    flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        startPostgresqlScript = pkgs.writeShellScriptBin "start-postgresql" ''
          pg_ctl start -l $LOG_PATH -o "-c listen_addresses= -c unix_socket_directories=$PGHOST"
        '';
      in {
       devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            (postgresql_14.withPackages (ps: [
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
