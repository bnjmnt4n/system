{pkgs, ...}: {
  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

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
