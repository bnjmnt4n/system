{ config, lib, pkgs, ... }:

let
  scripts = import ../../lib/scripts.nix { inherit pkgs; };
in
{
  imports = [
    ../../home/base.nix
    ../../home/tarsnap.nix

    ../../home/shell.nix
    ../../home/xdg.nix
    ../../home/git.nix
    ../../home/gpg.nix

    ../../home/bat.nix
    ../../home/difftastic.nix # ../../home/delta.nix
    ../../home/tmux.nix

    ../../home/helix.nix
    ../../home/neovim
  ];

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  targets.genericLinux.enable = true;
  # Login shell
  programs.bash.profileExtra = ''
    # TODO: some form of WSL services?
    eval $(gpg-agent --daemon &>/dev/null)

    # Switch to fish shell.
    if [[ -t 1 && -x ~/.nix-profile/bin/fish ]]; then
        exec ~/.nix-profile/bin/fish -l
    fi
  '';

  # Disable Ubuntu login message.
  home.file.".hushlogin".text = "";

  home.packages = with pkgs; [
    canvas-downloader
    hledger
    restic
    scripts.setupResticEnv
    yt-dlp
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
