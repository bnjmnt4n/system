{pkgs, ...}: {
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  programs.home-manager.enable = true;

  programs.nix-index.enable = true;

  programs.nh.enable = true;

  home.packages = with pkgs; [
    alejandra
    nixd
    nix-tree

    scripts.nixFlakeInit
    scripts.nixFlakeSync
  ];
}
