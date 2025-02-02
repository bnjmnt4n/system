{pkgs, ...}: {
  imports = [
    ../../home/base.nix
    ../../home/tarsnap.nix

    ../../home/shell.nix
    ../../home/xdg.nix
    ../../home/git.nix
    ../../home/gpg.nix

    ../../home/bat.nix
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
    hledger
    restic
    yt-dlp
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
