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
  cfg = config.${namespace}.cli.git;
in {
  options.${namespace}.cli.git = {
    enable = mkBoolOpt false "Whether to enable git configuration.";
  };
  config = mkIf cfg.enable {
    ${namespace}.home.extraOptions = {
      programs.git = {
        enable = true;

        userName = config.${namespace}.user.name;
        userEmail = config.${namespace}.user.email;

        extraConfig = {
          color.ui = "auto";
        };

        delta = {
          enable = true;
          options = {
            side-by-side = true;
          };
        };
      };
    };
  };
}
