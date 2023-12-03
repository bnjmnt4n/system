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
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = true;
    };
    global.brewfile = true;
    # TODO: Replace with Nix-packaged Podman
    casks = [
      "podman-desktop"
    ];
  };

  environment.systemPackages = [
    pkgs.chromium-darwin
    pkgs.firefox-bin
    pkgs.hammerspoon
    pkgs.vlc-darwin
    # pkgs.podman
    # pkgs.podman-compose
    pkgs.wezterm
    # pkgs.zed
    pkgs.zoom-us
  ];

  services.nix-daemon.enable = true;

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
      tilesize = 72;
      showhidden = true;
      mru-spaces = false;
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
      pkgs.inter
    ];
  };
}
