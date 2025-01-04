{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "*" = {
        extraOptions = {
          "IgnoreUnknown" = "AddKeysToAgent,UseKeychain";
          "UseKeychain" = "yes";
          "IdentityAgent" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "${config.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        };
      };
    };
  };
}
