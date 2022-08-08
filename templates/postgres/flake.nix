{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=12363fb6d89859a37cd7e27f85288599f13e49d9";
    flake-utils.url = "github:numtide/flake-utils?rev=7e2a3b3dfd9af950a856d66b0a7d01e3c18aa249";
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
