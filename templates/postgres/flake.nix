{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=d87b72206aadebe6722944f541f55d33fd7046fb";
    flake-utils.url = "github:numtide/flake-utils?rev=74f7e4319258e287b0f9cb95426c9853b282730b";
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
