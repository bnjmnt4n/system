{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=63678e9f3d3afecfeafa0acead6239cdb447574c";
    flake-utils.url = "github:numtide/flake-utils?rev=ff7b65b44d01cf9ba6a71320833626af21126384";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in {
       devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.ocamlformat
          ] ++ (with pkgs.ocamlPackages; [
            ocaml
            dune_2
            core
            batteries
            num
            menhir
            menhirLib
            ocaml-lsp
            ocamlformat-rpc-lib
            findlib
            utop
            merlin
          ]);
        };
      });
}
