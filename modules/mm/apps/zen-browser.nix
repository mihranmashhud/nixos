{inputs, ...}: let
  mkLockedAttrs = builtins.mapAttrs (_: value: {
    Value = value;
    Status = "locked";
  });
in {
  mm.apps.zen-browser.homeManager = {pkgs, ...}: {
    imports = with inputs; [
      zen-browser.homeModules.beta
    ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];
      policies = {
        Preferences = mkLockedAttrs {
          "media.ffmpeg.vaapi.enabled" = true;
          "browser.tabs.hoverPreview.enabled" = true;
        };
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
      };
      profiles.default = rec {
        settings = {
          "privacy.webrtc.hideGlobalIndicator" = true;
          "zen.view.use-single-toolbar" = false;
          "zen.welcome-screen.seen" = true;
          "zen.view.show-newtab-button-top" = false;
          "zen.workspaces.continue-where-left-off" = true;
          "zen.urlbar.behavior" = "normal";
        };
        containersForce = true;
        containers = {
          Personal = {
            id = 1;
            color = "blue";
            icon = "fingerprint";
          };
          Dawah = {
            id = 2;
            color = "red";
            icon = "circle";
          };
          Academia = {
            id = 3;
            color = "purple";
            icon = "fruit";
          };
          Work = {
            id = 4;
            color = "orange";
            icon = "briefcase";
          };
        };
        spacesForce = true;
        spaces = let
          mapContainerIds = builtins.mapAttrs (name: value: value // {container = containers.${name}.id;});
        in
          mapContainerIds {
            "Personal" = {
              id = "0b1ba42c-884c-4d87-9203-c65500464be5";
              position = 1000;
            };
            "Dawah" = {
              id = "703bc0ed-139a-4ff2-8ccf-6e90a720bf39";
              position = 2000;
            };
            "Academia" = {
              id = "e929eab6-cba8-49bb-8c3c-b675ec55093f";
              position = 3000;
            };
            "Work" = {
              id = "0cc9d658-6523-4d5e-b0f9-f86965325942";
              position = 4000;
            };
          };
        search = {
          force = true;
          default = "ddg";
          engines = let
            icon = "https://nixos.wiki/favicon.png";
          in {
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
              definedAliases = ["np"];
              inherit icon;
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = ["nw"];
              inherit icon;
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
              definedAliases = ["nop"];
              inherit icon;
            };
            "Noogle" = {
              urls = [
                {
                  template = "https://noogle.dev/q";
                  params = [
                    {
                      name = "term";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["noog"];
              inherit icon;
            };
            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master"; # unstable
                    }
                  ];
                }
              ];
              definedAliases = ["hmop"];
              inherit icon;
            };
            bing.metaData.hidden = "true";
          };
        };
      };
    };
  };
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
}
