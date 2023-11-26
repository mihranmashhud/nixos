{
  pkgs,
  config,
  ...
}: {
  home.sessionVariables = {
    BROWSER = "firefox";
  };
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      profiles.mihranmashhud = {
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
          "privacy.webrtc.hideGlobalIndicator" = true;
          "media.ffmpeg.vaapi.enabled" = true;
        };
        userChrome = ''
          #TabsToolbar {
            visibility: collapse !important;
          }
        '';
        search.engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["np"];
          };
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["nw"];
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["nop"];
          };
          "Bing".metaData.hidden = "true";
        };
        search.force = true;
        search.default = "DuckDuckGo";
      };
    };
  };
}
