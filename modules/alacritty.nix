{ pkgs, ... }:

{
  # Fast terminal emulator.
  programs.alacritty = {
    enable = true;
    settings = {
      background_opacity = 0.95;
      font.size = 12;

      # Colors (Doom One)
      # Obtained from https://github.com/eendroroy/alacritty-theme/blob/c1a8c5a9d492957433df48d7fc2251ab628dd223/themes/doom_one.yml.
      colors = {
        # Default colors
        primary = {
          background = "0x282c34";
          foreground = "0xbbc2cf";
        };
        # Normal colors
        normal = {
          black   = "0x282c34";
          red     = "0xff6c6b";
          green   = "0x98be65";
          yellow  = "0xecbe7b";
          blue    = "0x51afef";
          magenta = "0xc678dd";
          cyan    = "0x46d9ff";
          white   = "0xbbc2cf";
        };
      };
    };
  };
}
