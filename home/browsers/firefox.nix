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
          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffmpeg.vaapi-drm-display.enabled" = true;
        };
      };
    };
  };

  # TODO: merge into firefox.profiles?
  # If there are any updates to the search.json format, run:
  # nix-shell -p mozlz4a --command "mozlz4a -d ~/.mozilla/firefox/default/search.json.mozlz4 new.search.json"
  home.file.".mozilla/firefox/default/search.json.mozlz4" = let
    searchJsonMozlz4 = pkgs.runCommand "generate-search-json-mozlz4" {} ''
      mkdir $out
      ${pkgs.jq}/bin/jq -c . < ${./firefox.search.json} > $out/compressed.json
      ${pkgs.mozlz4a}/bin/mozlz4a $out/compressed.json $out/search.json.mozlz4
    '';
  in {
    source = "${searchJsonMozlz4}/search.json.mozlz4";
    force = true;
  };
}
