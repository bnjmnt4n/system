{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      decentraleyes
      h264ify
      https-everywhere
      multi-account-containers
      temporary-containers
      privacy-badger
      react-devtools
      ublock-origin
      vimium
    ];

    profiles = {
      default = {
        isDefault = true;
        userChrome = pkgs.lib.readFile ./firefox.userChrome.css;
        settings = {
          "browser.ctrlTab.recentlyUsedOrder" = false;
          "browser.search.hiddenOneOffs" = "Google,Yahoo,Bing,Amazon.com,Twitter";
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "extensions.pocket.enabled" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };
  };
}
