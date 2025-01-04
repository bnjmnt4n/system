{
  config,
  pkgs,
  ...
}: {
  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };
}
