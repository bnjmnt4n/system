{ config, pkgs, ... }:

{
  # Fish shell.
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting

      # WSL doesn't set the SHELL
      ${if config.targets.genericLinux.enable 
        then ''
          set -x SHELL ${pkgs.fish}/bin/fish
        ''
        else ""}
    '';
    interactiveShellInit = ''
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

    nix-direnv.enable = true;
    stdlib = pkgs.lib.readFile ./.direnvrc;
  };

  # Fast Rust-powered shell prompt.
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      format = "$all$linebreak$character";
      # Add indicator for bash shell.
      shell = {
        disabled = false;
        bash_indicator = "bsh ";
        fish_indicator = "";
        style = "bold";
        format = "[$indicator]($style)";
      };
    };
  };

  # Directory switcher.
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
