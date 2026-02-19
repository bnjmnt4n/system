{
  config,
  pkgs,
  ...
}: {
  # Fish shell.
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting

      # WSL doesn't set the SHELL
      ${
        if config.targets.genericLinux.enable
        then ''
          set -x SHELL ${pkgs.fish}/bin/fish
        ''
        else ""
      }
    '';
    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
  };

  # Bash shell.
  programs.bash.enable = true;

  # # Nushell.
  # programs.nushell.enable = true;

  # Switch environments easily.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
        echo "''${direnv_layout_dirs[$PWD]:=$(
          hash="$(${pkgs.coreutils}/bin/sha1sum - <<< "$PWD" | head -c40)"
          path="''${PWD//[^a-zA-Z0-9]/-}"
          echo "$XDG_CACHE_HOME/direnv/layouts/$hash$path"
        )}"
      }
    '';
    config = {
      warn_timeout = "0s"; # Disable warning
    };
  };

  # Fast Rust-powered shell prompt.
  programs.starship = {
    enable = true;
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
  };
}
