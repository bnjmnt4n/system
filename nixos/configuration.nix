{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./overlays.nix
      ./fonts.nix
      ./emacs.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    dunst
    fd
    file
    fzf
    gitAndTools.gitFull
    gitAndTools.gh
    gvfs
    less
    ledger
    maim
    pass
    pandoc
    ripgrep
    rofi
    rsync
    starship
    tree
    wget
    xclip
    xdg_utils

    # System bar and trays
    polybarFull
    networkmanagerapplet
    blueman
    pasystray

    # Lightweight locker for lightdm.
    lightlocker

    # Archiving
    unzip
    unrar
    xz
    zip

    # File manager
    xfce.thunar

    # Browser
    firefox

    # Editors
    vscode
    vim

    # Media
    gimp
    playerctl
    spotify
    vlc

    # PDF
    ghostscript
    zathura

    # Screencasting
    simplescreenrecorder
    gifsicle
    imagemagick

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
    redshift
    tdesktop

    # Videoconferencing
    zoom-us # hmmm...
    teams

    # LumiNUS CLI client
    fluminurs
  ];

  # Convenient shell integration with nix-shell.
  services.lorri.enable = true;

  # Fish shell.
  programs.fish.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # Only the full PulseAudio build has Bluetooth support.
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Configure DPI for my laptop.
  # Reference: https://gist.github.com/domenkozar/b3c945035af53fa816e0ac460f1df853#x-server-resolution
  # TODO: should this be in a separate specialized module?
  services.xserver.monitorSection = ''
    DisplaySize 338 190
  '';

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Use lightdm.
  services.xserver.displayManager.lightdm = {
    enable = true;
    background = /home/bnjmnt4n/background-image;
    greeters.gtk.indicators = [ "~clock" "~session" "~power" ];
  };

  # Use i3wm.
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;

  # Use picom compositor.
  services.picom.enable = true;
  services.picom.vSync = true;
  services.picom.backend = "glx";

  # Secrets management.
  services.gnome3.gnome-keyring.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

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
