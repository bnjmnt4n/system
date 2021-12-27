{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=d87b72206aadebe6722944f541f55d33fd7046fb";
    flake-utils.url = "github:numtide/flake-utils?rev=74f7e4319258e287b0f9cb95426c9853b282730b";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in {
       devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            go_1_17
            gopls
          ];
        };
      });
}
