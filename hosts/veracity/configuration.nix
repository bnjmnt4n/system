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
    };
    global.brewfile = true;
    brews = [
      "comby" # pkgs.comby is currently broken on darwin
    ];
    casks = [
      "aldente"
      # "bitwarden"
      "calibre"
      "cursor"
      # "docker"
      "dropbox"
      "figma"
      "firefox"
      "ghostty"
      # "handbrake"
      "imageoptim"
      "knockknock"
      "lulu"
      "monodraw"
      "mullvad-browser"
      "mullvad-vpn"
      "obsidian"
      "oversight"
      "google-chrome"
      # "safari-technology-preview"
      "secretive"
      "spotify"
      # "tor-browser"
      "transmission"
      "vlc"
    ];
  };

  services.karabiner-elements = {
    enable = true;
    # Karabiner Elements 15.0 is not supported yet in nix-darwin.
    # https://github.com/LnL7/nix-darwin/issues/1041
    package = pkgs.karabiner-elements.overrideAttrs (old: {
      version = "14.13.0";
      src = pkgs.fetchurl {
        inherit (old.src) url;
        hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
      };
      dontFixup = true;
    });
  };

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
        "/Applications/Ghostty.app/"
        {spacer = {small = true;};}
        "/Applications/Spotify.app/"
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
