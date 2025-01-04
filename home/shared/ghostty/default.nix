{pkgs, ...}: {
  home.packages =
    if pkgs.stdenv.hostPlatform.isDarwin
    # Installed via Homebrew for Darwin.
    then []
    else [pkgs.ghostty];

  xdg.configFile."ghostty/themes".source = ./themes;
  home.file."Library/Application Support/com.mitchellh.ghostty/config".source = ./config;
}
