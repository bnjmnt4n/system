{ pkgs, ... }:

{
  home.packages = with pkgs; [
    chromium
  ];

  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      h264ify
      https-everywhere
      multi-account-containers
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
