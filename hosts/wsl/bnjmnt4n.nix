{ config, lib, pkgs, ... }:

{
  imports = [
    ../../home/base.nix

    ../../home/shell.nix
    ../../home/xdg.nix
    ../../home/git.nix
    ../../home/gpg.nix

    ../../home/bat.nix
    ../../home/delta.nix
    ../../home/tmux.nix

    ../../home/firefox/default.nix

    ../../home/emacs/default.nix
    ../../home/neovim/default.nix

  ];

  # TODO: remove?
  home.username = "bnjmnt4n";
  home.homeDirectory = "/home/bnjmnt4n";

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  targets.genericLinux.enable = true;
  programs.bash.initExtra = ''
    # Switch to fish shell.
    if [[ -t 1 && -x ~/.nix-profile/bin/fish ]]; then
        exec ~/.nix-profile/bin/fish
    fi
  '';

  # Disable Ubuntu login message.
  home.file.".hushlogin".text = "";

  home.packages = with pkgs; [
    dos2unix
    socprint
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GDK_DPI_SCALE = 1.5;
    MOZ_ENABLE_WAYLAND = 1;
  };
}
