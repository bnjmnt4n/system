{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=85b081528b937df4bfcaee80c3541b58f397df8b";
    flake-utils.url = "github:numtide/flake-utils?rev=cfacdce06f30d2b68473a46042957675eebb3401";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in {
       devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs-16_x
            yarn
            nodePackages.typescript-language-server
            nodePackages.vscode-langservers-extracted
            nodePackages."@tailwindcss/language-server"
          ];
        };
      });
}
