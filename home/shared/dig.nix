{ pkgs, ... }:

{
  home.file.".digrc".text = ''
    +noall +answer
  '';

  home.packages = [ pkgs.dig ];
}
