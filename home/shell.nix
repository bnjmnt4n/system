{ config, pkgs, ... }:

{
  # Fish shell.
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
    '';
    promptInit =
      # TODO: any-nix-shell doesn't work well on WSL.
      if config.targets.genericLinux.enable
      then ""
      else ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
  };

  # Bash shell.
  programs.bash.enable = true;

  # Nushell.
  programs.nushell.enable = true;

  # Switch environments easily.
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
    stdlib = pkgs.lib.readFile ./.direnvrc;
  };

  # Fast Rust-powered shell prompt.
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  # Directory switcher.
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
