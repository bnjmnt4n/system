{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      ia-writer-duospace
      inter
      # iosevka-bin
      (nerdfonts.override {fonts = ["Iosevka"];})
      jetbrains-mono
      libre-baskerville
      overpass
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Iosevka"];
        sansSerif = ["Source Sans Pro"];
        serif = ["Source Serif Pro"];
      };
    };
  };
}
