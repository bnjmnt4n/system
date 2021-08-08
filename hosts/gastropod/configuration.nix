{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../nixos/nix.nix
    ../../nixos/binary-caches.nix

    ../../nixos/defaults.nix
    ../../nixos/console-font.nix
    ../../nixos/interception-tools.nix
    ../../nixos/bootloader/grub.nix
    ../../nixos/login/greetd.nix

    ../../nixos/fonts.nix

    ../../nixos/tailscale.nix
  ];

  boot.kernel.sysctl = {
    # Allow for a greater number of inotify watches.
    "fs.inotify.max_user_watches" = 524288;
    # Allow all sysrq functions.
    "kernel.sysrq" = 1;
  };

  # Use a recent Linux kernel (5.12).
  boot.kernelPackages = pkgs.linuxPackages_5_12;
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

  networking.firewall.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "9.9.9.9" ];

  # Enable SSH.
  services.openssh.enable = true;

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

  # Power management.
  services.upower.enable = true;
  powerManagement.powertop.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.udev.packages = [ pkgs.android-udev-rules ];

  # Default user account. Remember to set a password via `passwd`.
  users.users.bnjmnt4n = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "audio"
      "docker"
      "input"
      "networkmanager"
      "sway"
    ];
  };

  # Sway.
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraPackages = [ ];
  };

  environment.systemPackages = with pkgs; [
    networkmanager-fortisslvpn # NUS VPN
    capitaine-cursors
  ];

  # Secrets management.
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Enable WebRTC-based screen-sharing.
  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = with pkgs;
      [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };
}
