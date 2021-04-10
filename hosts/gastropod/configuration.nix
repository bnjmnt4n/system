{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../nixos/binary-caches.nix

    ../../nixos/console-font.nix
    ../../nixos/bootloader/grub.nix # ../../nixos/bootloader/systemd-boot.nix
    ../../nixos/login/greetd.nix # ../../nixos/login/lightdm.nix

    ../../nixos/fonts.nix
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "bnjmnt4n" ];
  };

  # Allow for a greater number of inotify watches.
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  # Use a recent Linux kernel (5.11).
  boot.kernelPackages = pkgs.linuxPackages_5_11;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  # Hardware accelerated video playback.
  # See https://nixos.wiki/wiki/Accelerated_Video_Playback.
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  networking.hostName = "gastropod";
  networking.networkmanager.enable = true; # Alternative to wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # Over-ridden by `console-font` module.
    # font = "Lat2-Terminus16";
    keyMap = "us";
  };

  location = {
    latitude = 1.3521;
    longitude = 103.8198;
  };

  time.timeZone = "Asia/Singapore";

  # Enable sound and Bluetooth.
  sound.enable = true;
  hardware.bluetooth.enable = true;

  # Enable blueman applet.
  services.blueman.enable = true;

  # Pipewire.
  # See https://github.com/NixOS/nixpkgs/issues/102547.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    media-session.enable = true;
    media-session.config.bluez-monitor.properties = {
      "bluez5.msbc-support" = true;
      "bluez5.sbc-xq-support" = true;
    };
  };

  # Map CapsLock to Esc on single press and Ctrl on when used with multiple keys.
  services.interception-tools.enable = true;

  # Power management.
  services.upower.enable = true;
  powerManagement.powertop.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.udev.packages = [ pkgs.android-udev-rules ];

  # Default user account. Remember to set a password via `passwd`.
  users.users.bnjmnt4n = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel" "networkmanager" "docker" "sway" "audio"
    ];
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";

  # Sway.
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraPackages = [];
  };

  environment.systemPackages = with pkgs; [
    networkmanager-fortisslvpn # NUS VPN
    capitaine-cursors
  ];

  # Secrets management.
  services.gnome3.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Enable WebRTC-based screen-sharing.
  xdg.portal.enable = true;
  xdg.portal.gtkUsePortal = true;
  xdg.portal.extraPortals = with pkgs;
    [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
}
