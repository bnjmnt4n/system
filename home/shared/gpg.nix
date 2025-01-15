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

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = pkgs.fetchurl {
          url = "https://github.com/bnjmnt4n.gpg";
          hash = "sha256-2aHsGA9Qak4/DUdbLqU3NRYsT3nkCzpZoQPZRwxzNy8=";
        };
        trust = "ultimate";
      }
      {
        source = pkgs.fetchurl {
          url = "https://github.com/web-flow.gpg";
          hash = "sha256-bor2h/YM8/QDFRyPsbJuleb55CTKYMyPN4e9RGaj74Q=";
        };
        trust = "full";
      }
    ];
    settings.default-key = "A853F0716C413825";
  };

  # Mac-specific configuration.
  # TODO: do we need to initiate a service?
  home.file = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    ".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}
    '';
  };
}
