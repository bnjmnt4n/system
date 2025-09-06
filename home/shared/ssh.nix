{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "yes";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        identityAgent = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "${config.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        extraOptions = {
          "IgnoreUnknown" = "AddKeysToAgent,UseKeychain";
          "UseKeychain" = "yes";
        };
      };
    };
  };
}
