{ config, pkgs, ... }:

let
  SSH_AUTH_SOCK = "${config.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
in
{
  home.packages = [ pkgs.secretive ];

  launchd.agents.secretive = {
    enable = true;
    config = {
      ProgramArguments = [ "${config.home.homeDirectory}/Applications/Home Manager Apps/${pkgs.secretive.sourceRoot}/Contents/Library/LoginItems/SecretAgent.app/Contents/MacOS/SecretAgent" ];
      KeepAlive = { SuccessfulExit = false; };
      ProcessType = "Interactive";
      StandardOutPath = "${config.xdg.cacheHome}/Secretive.log";
      StandardErrorPath = "${config.xdg.cacheHome}/Secretive.log";
    };
  };

  targets.darwin.defaults."com.maxgoedjen.Secretive.Host" = {
    defaultsHasRunSetup = true;
  };

  home.sessionVariables = {
    inherit (SSH_AUTH_SOCK);
  };

  programs.ssh.matchBlocks."*".extraOptions."IdentityAgent" = SSH_AUTH_SOCK;
}
