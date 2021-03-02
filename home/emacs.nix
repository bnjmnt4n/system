{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtkGcc;
    extraPackages = epkgs: [
      epkgs.vterm
      (epkgs.telega.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.tdlib ];
        nativeBuildInputs = [ pkgs.pkg-config ];

        patches = [
          (pkgs.fetchpatch {
            name = "telega-server-bin-store-prefer.patch";
            url = "https://github.com/zevlg/telega.el/commit/72550f984ca869309d197203ef7de99182d71729.patch";
            sha256 = "18xvz53bygksak6h5f8cz79y83p2va15i8qz7n4s3g9gsklmkj2p";
          })
        ];

        postPatch = ''
          substituteInPlace telega-customize.el \
            --replace 'defcustom telega-server-command "telega-server"' \
                      "defcustom telega-server-command \"$out/bin/telega-server\""
          substituteInPlace telega-sticker.el --replace '"dwebp"' '"${pkgs.libwebp}/bin/dwebp"'
          substituteInPlace telega-vvnote.el --replace '"ffmpeg' '"${pkgs.ffmpeg}/bin/ffmpeg'
        '';

        postBuild = ''
          cd source/server
          make
          cd -
        '';


        postInstall = ''
          mkdir -p $out/bin
          install -m755 -Dt $out/bin ./source/server/telega-server
        '';
      }))
    ];
  };
  services.emacs.enable = true;

  # Include Doom Emacs CLI in PATH.
  home.sessionPath = [ "${config.home.homeDirectory}/.emacs.d/bin" ];

  home.packages = with pkgs; [
    imagemagick
    ripgrep
    coreutils
    fd
    clang
    texlive.combined.scheme-full

    (makeDesktopItem {
      name = "org-protocol";
      exec = "emacsclient %u";
      comment = "Org Protocol";
      desktopName = "org-protocol";
      type = "Application";
      mimeType = "x-scheme-handler/org-protocol";
    })
  ];
}
