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
  cfg = config.${namespace}.nix;
  substituters-submodule = types.submodule {
    options = with types; {
      url = mkOption {
        description = "URL of the substituter.";
        type = str;
      };
      key = mkOption {
        description = "The trusted public key for this substituter.";
        type = str;
      };
    };
  };
in {
  options.${namespace}.nix = with types; {
    enable = mkBoolOpt true "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.nix "Which nix package to use.";

    default-substituter = {
      url = mkOpt str "https://cache.nixos.org" "The url for the substituter.";
      key = mkOpt str "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "The trusted public key for the substituter.";
    };

    extra-substituters = mkOpt (listOf substituters-submodule) [] "Extra substituters to configure.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alejandra
      deploy-rs
      nix-index
      nix-output-monitor
      snowfallorg.flake
      snowfallorg.thaw
    ];

    nix = let
      users = ["root" config.${namespace}.user.name];
    in {
      package = cfg.package;

      settings = {
        experimental-features = "nix-command flakes";

        http-connections = 50;
        log-lines = 50;
        warn-dirty = false;
        auto-optimise-store = true;
        trusted-users = users;
        allowed-users = users;

        substituters = [cfg.default-substituter.url] ++ (map (x: x.url) cfg.extra-substituters);
        trusted-public-keys = [cfg.default-substituter.key] ++ (map (x: x.key) cfg.extra-substituters);
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
