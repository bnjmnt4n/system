{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin
      # Installed via Homebrew for Darwin.
      then null
      else pkgs.ghostty;
    settings = {
      font-family = "Iosevka";
      font-size = "20";
      theme = "light:modus_operandi,dark:modus_vivendi";
      cursor-style = "block";
      window-padding-x = "10";
      macos-option-as-alt = "true";
      macos-titlebar-proxy-icon = "visible";
      quick-terminal-animation-duration = "0";
      keybind = "global:super+ctrl+shift+alt+space=toggle_quick_terminal";
      shell-integration = "none"; # Handled by home-manager
      shell-integration-features = "no-cursor";
    };
  };

  xdg.configFile."ghostty/themes".source = ./themes;
}
