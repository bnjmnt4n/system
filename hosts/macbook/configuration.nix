{ pkgs, ... }:

{
  imports = [
    ../../nixos/nix.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "macbook";

  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;
  programs.fish.loginShellInit = ''
    fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin /nix/var/nix/profiles/default/bin
  '';

  services.nix-daemon.enable = true;
  services.karabiner-elements.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    trackpad.Clicking = true;
    trackpad.TrackpadRightClick = true;
    dock.autohide = true;
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
  };
}
