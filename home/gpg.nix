{ pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    defaultCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtl = 34560000;
    maxCacheTtlSsh = 34560000;
  };

  home.packages = [
    pkgs.gnupg
  ];
}
