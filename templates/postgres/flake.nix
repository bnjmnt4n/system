{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=90e85bc7c1a6fc0760a94ace129d3a1c61c3d035";
    flake-utils.url = "github:numtide/flake-utils?rev=ff7b65b44d01cf9ba6a71320833626af21126384";
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
