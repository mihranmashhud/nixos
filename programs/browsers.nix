{ pkgs, config, ... }: {
  home.sessionVariables = {
    BROWSER = "firefox";
  };
  programs = {
    firefox = {
      enable = true;
      profiles.mihranmashhud = {
        settings = {
          # Enable userChrome.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome = ''
          #TabsToolbar {
            visibility: collapse !important;
          }
        '';
        search.engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
              { name = "type"; value = "packages"; }
              { name = "channel"; value = "unstable"; }
              { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "np" ];
          };
          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "nw" ];
          };
          "Bing".metaData.hidden = "true";
        };
        search.force = true;
        search.default = "DuckDuckGo";
      };
    };
  };
}
