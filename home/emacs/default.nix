{ config, lib, pkgs, inputs, ... }:

let
  customEmacs = pkgs.emacsPgtk;
  emacsSetupScript = pkgs.writeScript "emacs-setup" ''
    #!/bin/sh
    set -eux
    export PATH="${lib.makeBinPath [ customEmacs pkgs.bash pkgs.coreutils pkgs.git pkgs.sqlite pkgs.unzip ]}"

    if [ ! -d $HOME/.emacs.d/.git ]; then
      mkdir -p $HOME/.emacs.d
      git -C $HOME/.emacs.d init
    fi

    if [ $(git -C $HOME/.emacs.d rev-parse HEAD) != "${inputs.doom-emacs.rev}" ]; then
      git -C $HOME/.emacs.d fetch https://github.com/doomemacs/doomemacs.git
      git -C $HOME/.emacs.d checkout ${inputs.doom-emacs.rev}
      $HOME/.emacs.d/bin/doom sync
    fi
  '';
in
{
  home.activation.emacsSetup = lib.hm.dag.entryAfter [ "installPackages" "linkGeneration" ] ''
    ${emacsSetupScript}
  '';

  programs.emacs = {
    enable = true;
    package = customEmacs;
    extraPackages = epkgs: [
      epkgs.vterm
    ];
  };

  services.emacs.enable = true;
  # Start after graphical session so we can read/write from Wayland keyboard
  # without having to restart the daemon.
  systemd.user.services.emacs = {
    Unit.After = [ "graphical-session.target" ];
    Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
  };

  # Include Doom Emacs CLI in PATH.
  home.sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin" ];

  # Doom Emacs configuration files.
  xdg.configFile."doom" = {
    source = ./doom;
    onChange = ''
      $HOME/.emacs.d/bin/doom sync
    '';
  };

  home.packages = with pkgs; [
    imagemagick
    ripgrep
    coreutils
    fd
    texlive.combined.scheme-full
    clang # Used to compile sqlite

    (makeDesktopItem {
      name = "org-protocol";
      exec = "emacsclient %u";
      comment = "Org Protocol";
      desktopName = "org-protocol";
      type = "Application";
      mimeTypes = [ "x-scheme-handler/org-protocol" ];
    })
  ];
}
