{
  pkgs,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin
      # Installed in `environment.systemPackages` for Darwin.
      then pkgs.emptyDirectory
      else pkgs.firefox;

    policies = {
      EnterprisePoliciesEnabled = true;
      DisableAppUpdate = true;
    };

    profiles = {
      default = {
        isDefault = true;
        userChrome = pkgs.lib.readFile ./userChrome.css;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons;
          [
            bitwarden
            decentraleyes
            multi-account-containers
            temporary-containers
            privacy-badger
            react-devtools
            ublock-origin
            vimium
          ]
          ++ (
            if (pkgs.stdenv.hostPlatform.isDarwin)
            then []
            else
              with pkgs.nur.repos.rycee.firefox-addons; [
                h264ify
              ]
          );
        settings = {
          "app.update.auto" = false;
          "browser.startup.page" = 3; # Restore previous tabs
          "browser.ctrlTab.recentlyUsedOrder" = false;
          "browser.search.hiddenOneOffs" = "";
          "browser.urlbar.suggest.searches" = false;
          "browser.uidensity" = 1; # Compact density
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "extensions.pocket.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Reduce File IO / SSD abuse.
          # This forces it to write every 1 minute, rather than 15 seconds.
          "browser.sessionstore.interval" = "60000";

          # TODO: Make Linux only
          # Hardware acceleration related settings.
          # "gfx.webrender.all" = true;
          # "widget.wayland-dmabuf-vaapi.enabled" = true;
          # "media.ffmpeg.vaapi.enabled" = true;
          # "media.ffmpeg.vaapi-drm-display.enabled" = true;
        };
        search = {
          force = true;
          default = "ddg";
          engines = {
            # Default search engines.
            "ddg".metaData.alias = "@d";
            "google".metaData.alias = "@g";
            "wikipedia".metaData.alias = "@wk";
            "amazondotcom-us".metaData.hidden = true;
            "bing".metaData.hidden = true;
            "ebay".metaData.hidden = true;

            "YouTube" = {
              urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
              definedAliases = ["@yt"];
              icon = "https://www.youtube.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "GitHub (Code)" = {
              urls = [{template = "https://github.com/search?q={searchTerms}&type=code";}];
              definedAliases = ["@ghc"];
              icon = "https://github.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "GitHub (Issues)" = {
              urls = [{template = "https://github.com/search?q={searchTerms}&type=issues";}];
              definedAliases = ["@ghi"];
              icon = "https://github.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "GitHub (Repositories)" = {
              urls = [{template = "https://github.com/search?q={searchTerms}&type=repositories";}];
              definedAliases = ["@ghr"];
              icon = "https://github.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "Twitter" = {
              urls = [{template = "https://twitter.com/search?q={searchTerms}";}];
              definedAliases = ["@tw"];
              icon = "https://abs.twimg.com/favicons/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "Genius" = {
              urls = [{template = "https://genius.com/search?q={searchTerms}";}];
              definedAliases = ["@gen"];
              icon = "https://genius.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "Stack Overflow" = {
              urls = [{template = "https://stackoverflow.com/search?q={searchTerms}";}];
              definedAliases = ["@so"];
              icon = "https://cdn.sstatic.net/Sites/stackoverflow/Img/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "NixOS Packages" = {
              urls = [{template = "https://search.nixos.org/packages?channel=unstable&type=packages&query={searchTerms}";}];
              definedAliases = ["@nixp"];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "NixOS Options" = {
              urls = [{template = "https://search.nixos.org/options?channel=unstable&type=packages&query={searchTerms}";}];
              definedAliases = ["@nixo"];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "Nixpkgs PRs" = {
              urls = [{template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}";}];
              definedAliases = ["@nixpr"];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "Home Manager Options" = {
              urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";}];
              definedAliases = ["@hm"];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "npm" = {
              urls = [{template = "https://www.npmjs.com/search?q={searchTerms}";}];
              definedAliases = ["@npm"];
              icon = "https://static-production.npmjs.com/b0f1a8318363185cc2ea6a40ac23eeb2.png";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "bundlephobia" = {
              urls = [{template = "https://bundlephobia.com/package/{searchTerms}";}];
              definedAliases = ["@bp"];
              icon = "https://bundlephobia.com/favicon-32x32.png";
              updateInterval = 24 * 60 * 60 * 1000;
            };
            "caniuse" = {
              urls = [{template = "http://caniuse.com/?search={searchTerms}";}];
              definedAliases = ["@cani"];
              icon = "https://caniuse.com/img/favicon-16.png";
              updateInterval = 24 * 60 * 60 * 1000;
            };
          };
          order = [
            "ddg"
            "google"
            "YouTube"
            "wikipedia"
            "GitHub (Code)"
            "GitHub (Issues)"
            "GitHub (Repositories)"
            "Twitter"
            "Genius"
            "Stack Overflow"
            "NixOS Packages"
            "NixOS Options"
            "Nixpkgs PRs"
            "Home Manager Options"
            "npm"
            "bundlephobia"
            "caniuse"
          ];
        };
      };
    };
  };

  # https://github.com/nix-community/home-manager/issues/3323
  launchd.agents.firefox-env = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = ["/bin/sh" "-c" "launchctl setenv MOZ_LEGACY_PROFILES 1; launchctl setenv MOZ_ALLOW_DOWNGRADE 1"];
      RunAtLoad = true;
    };
  };
}
