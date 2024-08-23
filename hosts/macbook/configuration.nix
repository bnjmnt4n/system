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
    casks = [
      "aldente"
      "betterdisplay"
      "docker"
      "figma"
      "mullvadvpn"
      "google-chrome"
      "safari-technology-preview"
      "transmission"
    ];
  };

  environment.systemPackages = [
    pkgs.firefox-bin
    pkgs.monitorcontrol
    pkgs.spotify
    pkgs.vlc-bin
    pkgs.wezterm
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
      persistent-apps = [
        "${pkgs.firefox-bin}/Applications/Firefox.app/"
        "${pkgs.wezterm}/Applications/WezTerm.app/"
        "${pkgs.zed}/Applications/${pkgs.zed.sourceRoot}/"
        "/Applications/Figma.app/"
        "${pkgs.spotify}/Applications/Spotify.app/"
        "/Applications/Google Chrome.app/"
        "/System/Cryptexes/App/System/Applications/Safari.app"
      ];
    };
  };

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
    pkgs.inter
    pkgs.iosevka-bin
    (pkgs.iosevka-bin.override { variant = "SGr-IosevkaTerm"; })
  ];
}
