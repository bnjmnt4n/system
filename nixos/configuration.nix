{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./overlays.nix
      ./fonts.nix
      ./emacs.nix
    ];

  nix.trustedUsers = [ "root" "bnjmnt4n" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use a recent Linux kernel (5.8).
  boot.kernelPackages = pkgs.linuxPackages_5_8;

  networking.hostName = "bnjmnt4n";
  networking.networkmanager.enable = true; # Alternative to wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  location = {
    latitude = 1.3521;
    longitude = 103.8198;
    # provider = "geoclue2";
  };

  time.timeZone = "Asia/Singapore";

  # System packages.
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Terminal emulator
    alacritty

    # System
    aspell
    aspellDicts.en
    brightnessctl
    direnv
    fd
    file
    fzf
    gitAndTools.gitFull
    gitAndTools.gh
    gvfs
    jq
    less
    ledger
    libsecret
    pass
    pandoc
    ripgrep
    rofi
    rsync
    starship
    tree
    wget
    xdg_utils

    # System bar and trays
    networkmanagerapplet

    # Archiving
    unzip
    unrar
    xz
    zip

    # File manager
    xfce.thunar

    # Browsers
    chromium
    firefox

    # Editors
    vscode
    vim

    # Media
    gimp
    # ffmpeg-full
    gifsicle
    imagemagick
    mpv
    playerctl
    spotify
    vlc

    # Screenshots/screen-recording
    grim
    slurp
    sway-contrib.grimshot
    wf-recorder

    # PDF
    ghostscript
    zathura

    # Database
    sqlite
    graphviz

    # Apps
    anki
    bitwarden
    bitwarden-cli
    dropbox
    musescore
    pavucontrol
    tdesktop
    webtorrent_desktop

    # Videoconferencing
    zoom-us # hmmm...
    teams

    # LumiNUS CLI client
    fluminurs

    (
      pkgs.writeTextFile {
        name = "startsway";
        destination = "/bin/startsway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
        '';
      }
    )
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound and Bluetooth.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # Only the full PulseAudio build has Bluetooth support.
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.enable = true;

  # Map CapsLock to Esc on single press and Ctrl on when used with multiple keys.
  services.interception-tools.enable = true;

  # Power management.
  powerManagement.enable = true;
  services.upower.enable = true;

  # Secrets management.
  services.gnome3.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Convenient shell integration with nix-shell.
  services.lorri.enable = true;

  # Fish shell.
  programs.fish.enable = true;

  # GDM.
  # TODO: this needs to be enabled even though we are running GDM on Wayland.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Sway window manager.
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock              # Lockscreen
      swayidle
      xwayland              # For legacy Xorg-based apps
      waybar                # Status bar
      mako                  # Notification daemon

      # TODO: not being used currently.
      kanshi                # Autorandr
      wofi
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND="1";
      export MOZ_USE_XINPUT2="1";
      export XDG_CURRENT_DESKTOP="sway";
      export XDG_SESSION_TYPE="wayland";
    '';
  };

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Wayland-based status bar.
  programs.waybar.enable = true;

  # Screen colour temperature management.
  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
  };

  # Enable WebRTC-based screen-sharing.
  # TODO: this is currently broken.
  services.pipewire.enable = true;

  xdg.portal.enable = true;
  xdg.portal.gtkUsePortal = true;
  xdg.portal.extraPortals = with pkgs;
    [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];

  # TODO: this is not used.
  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  # Default user account. Remember to set a password via `passwd`.
  users.users.bnjmnt4n = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel" "docker"
    ];
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";
}
