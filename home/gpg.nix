{ pkgs, lib, ... }:

{
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
  home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin [ pkgs.pinentry_mac ];
  home.file.".gnupg/gpg-agent.conf".text = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
    ''
      pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}
    '';
}
