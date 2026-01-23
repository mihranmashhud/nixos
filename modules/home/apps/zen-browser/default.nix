{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.apps.zen-browser;
  mkLockedAttrs = builtins.mapAttrs (_: value: {
    Value = value;
    Status = "locked";
  });
in {
  options.${namespace}.apps.zen-browser = {
    enable = mkBoolOpt false "Whether to enable zen-browser configuration.";
  };
  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      package = pkgs.zen-browser;
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
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      profiles.default = {
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
          i3 = {
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
          containers = config.programs.zen-browser.profiles."default".containers;
        in {
          "Personal" = {
            id = "0b1ba42c-884c-4d87-9203-c65500464be5";
            position = 1000;
          };
          "i3" = {
            id = "703bc0ed-139a-4ff2-8ccf-6e90a720bf39";
            position = 2000;
            container = containers."i3".id;
          };
          "Academia" = {
            id = "e929eab6-cba8-49bb-8c3c-b675ec55093f";
            position = 3000;
            container = containers."Academia".id;
          };
          "Work" = {
            id = "0cc9d658-6523-4d5e-b0f9-f86965325942";
            position = 4000;
            container = containers."Work".id;
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
              icon = icon;
              definedAliases = ["np"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              icon = icon;
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
              icon = icon;
              definedAliases = ["nop"];
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
              icon = icon;
              definedAliases = ["noog"];
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
              icon = icon;
              definedAliases = ["hmop"];
            };
            bing.metaData.hidden = "true";
          };
        };
      };
    };
  };
}
