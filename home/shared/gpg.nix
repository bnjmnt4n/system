{
  pkgs,
  lib,
  ...
}: {
  services.gpg-agent = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = true;
    defaultCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtl = 34560000;
    maxCacheTtlSsh = 34560000;
  };

  programs.gpg.enable = true;

  # Mac-specific configuration.
  # TODO: do we need to initiate a service?
  home.file = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    ".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}
    '';
  };
}
