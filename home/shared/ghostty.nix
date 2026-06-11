{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = with pkgs;
      if pkgs.stdenv.hostPlatform.isDarwin
      # Installed in `environment.systemPackages` for Darwin.
      then null
      else ghostty;
    settings = {
      auto-update = "off";
      font-family = "Iosevka";
      font-size = "20";
      theme = "light:modus_operandi_tinted,dark:modus_vivendi_tinted";
      cursor-style = "block";
      window-padding-x = "8";
      macos-option-as-alt = "true";
      macos-titlebar-style = "native";
      macos-titlebar-proxy-icon = "visible";
      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = "bell,notify";
      quick-terminal-animation-duration = "0";
      keybind = [
        "performable:cmd+shift+c=copy_url_to_clipboard"
      ];
      shell-integration = "none"; # Handled by home-manager
      shell-integration-features = "no-cursor,path";
    };
  };

  xdg.configFile."ghostty/themes".source = "${pkgs.modus-themes}/extras/ghostty";
}
