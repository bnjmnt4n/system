{pkgs, ...}: {
  imports = [
    ../../os/shared/nix.nix
  ];

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
      extraFlags = ["--force-cleanup"];
    };
    global.brewfile = true;
    casks = [
      # "bitwarden"
      "calibre"
      "docker"
      "dropbox"
      "figma"
      "firefox"
      "google-chrome"
      "lulu"
      "mullvad-browser"
      "mullvad-vpn"
      "oversight"
      # "safari-technology-preview"
      "spotify"
      # "tor-browser"
    ];
  };

  environment.systemPackages = with pkgs; [
    ghostty-bin
    obsidian
    syncthing-macos
  ];

  services.karabiner-elements.enable = true;

  # Use TouchID for `sudo`.
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      NSDocumentSaveNewDocumentsToCloud = false;
      # Full keyboard control.
      AppleKeyboardUIMode = 3;
    };
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 64;
      showhidden = true;
      mru-spaces = false;
      persistent-apps = [
        {spacer = {small = true;};}
        "/Applications/Firefox.app/"
        "/Applications/Mullvad Browser.app/"
        "/Applications/Google Chrome.app/"
        "/System/Cryptexes/App/System/Applications/Safari.app"
        {spacer = {small = true;};}
        "/Applications/Nix Apps/Ghostty.app/"
        {spacer = {small = true;};}
        "/Applications/Spotify.app/"
        "/Applications/Nix Apps/Obsidian.app/"
        "/System/Applications/Stickies.app/"
      ];
    };
  };

  environment.shellAliases.tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";

  fonts.packages = with pkgs; [
    inter
    iosevka-bin
    (iosevka-bin.override {variant = "SGr-IosevkaTerm";})
  ];
}
