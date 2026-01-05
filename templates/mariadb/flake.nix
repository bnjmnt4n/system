{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
    forEach = list: f: builtins.foldl' (acc: item: nixpkgs.lib.recursiveUpdate acc (f item)) {} list;
  in
    forEach systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      startMariadbScript = pkgs.writeScriptBin "start-mariadb" ''
        mysqld --datadir=$MYSQL_DATADIR --pid-file=$MYSQL_PID_FILE \
          --socket=$MYSQL_UNIX_PORT 2> $MYSQL_HOME/mysql.log &
        # export MYSQL_PID=$!
      '';
      endMariadbScript = pkgs.writeScriptBin "end-mariadb" ''
        mysqladmin -u root --socket=$MYSQL_UNIX_PORT shutdown
      '';
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          startMariadbScript
          endMariadbScript
          mariadb
        ];

        # https://jeancharles.quillet.org/posts/2022-01-30-Local-mariadb-server-with-nix-shell.html
        shellHook = ''
          export MYSQL_BASEDIR=${pkgs.mariadb}
          export MYSQL_HOME=$PWD/mysql
          export MYSQL_DATADIR=$MYSQL_HOME/data
          export MYSQL_UNIX_PORT=$MYSQL_HOME/mysql.sock
          export MYSQL_PID_FILE=$MYSQL_HOME/mysql.pid
          alias mysql='mysql -u root'

          if [ ! -d "$MYSQL_HOME" ]; then
            # Make sure to use normal authentication method otherwise we can only
            # connect with unix account. But users do not actually exists in nix.
            mariadb-install-db --auth-root-authentication-method=normal \
              --datadir=$MYSQL_DATADIR --basedir=$MYSQL_BASEDIR \
              --pid-file=$MYSQL_PID_FILE
          fi
        '';
      };
    });
}
