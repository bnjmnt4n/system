{pkgs, ...}: {
  imports = [
    ../../os/shared/nix.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "macbook";
  time.timeZone = "Asia/Singapore";

  environment.shells = [pkgs.fish];
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
      "dropbox"
      "figma"
      "firefox"
      "ghostty"
      "handbrake"
      "mullvadvpn"
      "google-chrome"
      "safari-technology-preview"
      "spotify"
      "transmission"
    ];
  };

  environment.systemPackages = with pkgs; [
    monitorcontrol
    vlc-bin
  ];

  services.karabiner-elements = {
    enable = true;
    package = pkgs.karabiner-elements;
  };

  # Use TouchID for `sudo`.
  security.pam.services.sudo_local.touchIdAuth = true;

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
        "/Applications/Firefox.app/"
        "/Applications/Ghostty.app/"
        "${pkgs.zed-editor}/Applications/Zed.app/"
        "/Applications/Figma.app/"
        "/Applications/Spotify.app/"
        "/Applications/Google Chrome.app/"
        "/System/Cryptexes/App/System/Applications/Safari.app"
      ];
    };
  };

  fonts.packages = with pkgs; [
    inter
    iosevka-bin
    (iosevka-bin.override {variant = "SGr-IosevkaTerm";})
  ];
}
