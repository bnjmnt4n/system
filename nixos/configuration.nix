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
    # Archiving
    unzip
    unrar
    xz
    zip

    # Browsers
    firefox

    # Media
    vlc

    # PDF
    zathura
    ghostscript

    # System
    aspell
    aspellDicts.en
    direnv
    fd
    file
    fzf
    gitAndTools.gitFull
    gvfs
    less
    ledger
    maim
    pass
    ripgrep
    rofi
    rsync
    starship
    tree
    wget
    xclip
    xdg_utils

    # Editors
    vscode
    vim

    # Music
    spotify
    musescore

    # Apps
    tdesktop
    dropbox

    # Video
    zoom-us # hmmm...
    teams

    # Screencasting
    simplescreenrecorder
    gifsicle
    scrot
    imagemagick

    sqlite
    graphviz

    # LumiNUS CLI client
    # fluminurs
  ];

  # Convenient shell integration with nix-shell.
  services.lorri.enable = true;

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
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Testing out Pantheon.
  services.xserver.desktopManager.pantheon.enable = true;

  # Secrets management.
  services.gnome3.gnome-keyring.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Default user account. Remember to set a password via `passwd`.
  users.users.bnjmnt4n = {
    isNormalUser = true;
    extraGroups = [
      "wheel" "docker"
    ];
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";
}
