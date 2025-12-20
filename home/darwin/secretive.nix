{config, ...}: let
  SSH_AUTH_SOCK = "${config.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
in {
  home.sessionVariables = {
    inherit SSH_AUTH_SOCK;
  };

  programs.ssh.matchBlocks."*".extraOptions."IdentityAgent" = SSH_AUTH_SOCK;
}
