{ pkgs, ... }:

{
  imports = [
    ../../os/shared/nix.nix

    ../../os/nixos/defaults.nix
    ../../os/nixos/fonts.nix

    ../../os/nixos/interception-tools.nix
    ../../os/nixos/tailscale.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  nix.autoOptimiseStore = true;

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  # Enable audio
  hardware.raspberry-pi."4".audio.enable = true;

  boot.kernel.sysctl = {
    # Allow all sysrq functions.
    "kernel.sysrq" = 1;
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    xfce.xfce4-systemload-plugin
  ];

  # TODO: figure out i2c stuff
  # systemd.services.argononed = {
  #   description = "Argon One Fan and Button Service";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     Restart = "always";
  #     RemainAfterExit = true;
  #     ExecStart = "${pkgs.argonone-rpi4}/opt/argonone/argononed.py";
  #   };
  # };

  networking.hostName = "raspy";
  networking.networkmanager.enable = true; # Alternative to wpa_supplicant.
  networking.firewall.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "9.9.9.9" ];

  # VPN setup
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.64.15.59/32" "fc00:bbbb:bbbb:bb01::1:f3a/128" ];
      dns = [ "193.138.218.74" ];
      privateKeyFile = "/run/secrets/wireguard-private-key";
      peers = [
        {
          allowedIPs = [ "0.0.0.0/0" "::0/0" ];
          publicKey = "HbD3PLJKJdHPyjof67Tug83HH5x/KyInbiuPQvkOaDI=";
          endpoint = "94.198.43.34:51820";
        }
      ];
      # Tailscale
      # TODO: check correctness
      # https://tailscale.com/kb/1105/other-vpns/
      postUp = "ip route add 100.64.0.0/10 dev tailscale0 && ip route add fd7a:115c:a1e0::/48 dev tailscale0";
      postDown = "ip route del 100.64.0.0/10 dev tailscale0 && ip route del fd7a:115c:a1e0::/48 dev tailscale0";
    };
  };

  # Enable SSH.
  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "none+i3";
    desktopManager.xfce.enable = true;
    windowManager.i3.enable = true;
  };
  security.pam.services.lightdm.enableGnomeKeyring = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable Bluetooth.
  # TODO: bluetooth is disabled for now.
  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.settings = {
  #   "General" = {
  #     "ControllerMode" = "le";
  #   };
  # };

  # Enable blueman applet.
  # services.blueman.enable = true;

  services.udev.packages = [ pkgs.android-udev-rules ];

  age.secrets.wireguard-private-key = {
    file = ../../secrets/wireguard-private-key.age;
  };

  # Default user account. Remember to set a password via `passwd`.
  users.users.bnjmnt4n = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "audio"
      "input"
      "networkmanager"
      "video"
    ];
  };
  users.users.guest = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "video"
    ];
  };

  # Secrets management.
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
}
