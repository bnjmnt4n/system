{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then pkgs.firefox-darwin else pkgs.firefox;

    profiles = {
      default = {
        isDefault = true;
        userChrome = pkgs.lib.readFile ./userChrome.css;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          decentraleyes
          h264ify
          multi-account-containers
          temporary-containers
          privacy-badger
          react-devtools
          ublock-origin
          vimium
        ];
        settings = {
          "browser.ctrlTab.recentlyUsedOrder" = false;
          "browser.search.hiddenOneOffs" = "";
          "browser.urlbar.suggest.searches" = false;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "extensions.pocket.enabled" = false;
          "middlemouse.paste" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # TODO: Make Linux only
          # Hardware acceleration related settings.
          # "gfx.webrender.all" = true;
          # "widget.wayland-dmabuf-vaapi.enabled" = true;
          # "media.ffmpeg.vaapi.enabled" = true;
          # "media.ffmpeg.vaapi-drm-display.enabled" = true;
        };
        search = {
          force = true;
          default = "DuckDuckGo";
          engines = {
            # Default search engines.
            "DuckDuckGo".metaData.alias = "@d";
            "Google".metaData.alias = "@g";
            "Wikipedia (en)".metaData.alias = "@wk";
            "Amazon.com".metaData.hidden = true;
            "Bing".metaData.hidden = true;

            "YouTube" = {
              urls = [{ template = "https//www.youtube.com/results?search_query={searchTerms}&page={startPage?}"; }];
              definedAliases = [ "@yt" ];
              iconUpdateUrl = "https://www.youtube.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "GitHub" = {
              urls = [{ template = "https//github.com/search?q={searchTerms}"; }];
              definedAliases = [ "@gh" ];
              iconUpdateUrl = "https://github.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "Twitter" = {
              urls = [{ template = "https://twitter.com/search?q={searchTerms}"; }];
              definedAliases = [ "@tw" ];
              iconUpdateUrl = "https://abs.twimg.com/favicons/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "Genius" = {
              urls = [{ template = "https://genius.com/search?q={searchTerms}"; }];
              definedAliases = [ "@gen" ];
              iconUpdateUrl = "https://assets.genius.com/images/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "Stack Overflow" = {
              urls = [{ template = "https://stackoverflow.com/search?q={searchTerms}"; }];
              definedAliases = [ "@so" ];
              iconUpdateUrl = "https://cdn.sstatic.net/Sites/stackoverflow/Img/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "NUSMods Modules" = {
              urls = [{ template = "https://nusmods.com/modules?q={searchTerms}"; }];
              definedAliases = [ "@nm" ];
              iconUpdateUrl = "https://nusmods.com/favicon-32x32.png";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "NixOS Packages" = {
              urls = [{ template = "https://search.nixos.org/packages?channel=unstable&type=packages&query={searchTerms}"; }];
              definedAliases = [ "@nixp" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "NixOS Options" = {
              urls = [{ template = "https://search.nixos.org/options?channel=unstable&type=packages&query={searchTerms}"; }];
              definedAliases = [ "@nixo" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "Nixpkgs PRs" = {
              urls = [{ template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}"; }];
              definedAliases = [ "@nixpr" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "Home Manager Options" = {
              urls = [{ template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}"; }];
              definedAliases = [ "@hm" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "npm" = {
              urls = [{ template = "https://www.npmjs.com/search?q={searchTerms}"; }];
              definedAliases = [ "@npm" ];
            };
            "bundlephobia" = {
              urls = [{ template = "https://bundlephobia.com/package/{searchTerms}"; }];
              definedAliases = [ "@bp" ];
              iconUpdateUrl = "https://bundlephobia.com/favicon-32x32.png";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "caniuse" = {
              urls = [{ template = "http://caniuse.com/?search={searchTerms}"; }];
              definedAliases = [ "@cani" ];
              iconUpdateUrl = "https://caniuse.com/img/favicon-16.png";
              updateInterval = 24 * 60 * 60 * 1000;
            };
          };
          order = [
            "DuckDuckGo"
            "Google"
            "Wikipedia (en)"
            "YouTube"
            "GitHub"
            "Twitter"
            "Genius"
            "Stack Overflow"
            "NUSMods Modules"
            "NixOS Packages"
            "NixOS Options"
            "Nixpkgs PRs"
            "home-manager Options"
            "npm"
            "bundlephobia"
            "caniuse"
          ];
        };
      };
    };
  };
}
