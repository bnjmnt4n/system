{ pkgs, ... }:

{
  imports = [
    ../../nixos/nix.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "macbook";
  time.timeZone = "Asia/Singapore";

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable = true;
    loginShellInit = ''
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin /nix/var/nix/profiles/default/bin /opt/homebrew/bin /opt/homebrew/sbin
    '';
  };

  homebrew = {
    enable = true;
    # global.brewfile = true;
    # onActivation = {
    #   autoUpdate = true;
    #   upgrade = true;
    #   cleanup = "zap";
    # };
    casks = [
      "google-chrome"
      "podman-desktop"
      "vlc"
      "zed"
    ];
  };

  environment.systemPackages = [
    pkgs.rectangle
    pkgs.zoom-us
  ];

  services.nix-daemon.enable = true;

  # TODO: add configuration.
  services.karabiner-elements.enable = true;

  # Use TouchID for `sudo`.
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
      showhidden = true;
    };
    # TODO: figure out system configuration for showing battery percentage in menu bar.
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
      pkgs.inter
    ];
  };
}