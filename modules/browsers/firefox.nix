{ pkgs, ... }:

let
  # TODO: figure out a better way to do this.
  searchJson = ./firefox.search.json;
  searchJsonMozlz4 = pkgs.stdenv.mkDerivation {
    pname = "search-json-mozlz4";
    version = "latest";
    src = ./.;
    phases = "installPhase";
    installPhase = ''
      ${pkgs.mozlz4a}/bin/mozlz4a ${searchJson} $out
    '';
  };
in
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
          "browser.urlbar.suggest.searches" = false;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "extensions.pocket.enabled" = false;
          "middlemouse.paste" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Hardware acceleration related settings.
          "gfx.webrender.all" = true;
          "widget.wayland-dmabuf-vaapi.enabled" = true;
        };
      };
    };
  };

  # TODO: merge into firefox.profiles?
  home.file.".mozilla/firefox/default/search.json.mozlz4".source = searchJsonMozlz4;
}
