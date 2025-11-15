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
  cfg = config.${namespace}.apps.vicinae;
in {
  options.${namespace}.apps.vicinae = {
    enable = mkBoolOpt false "Whether to enable vicinae configuration.";
  };
  config = mkIf cfg.enable {
    services.vicinae = {
      enable = true;
      autoStart = true;
      settings = {
        closeOnFocusLoss = true;
        popToRootOnClose = true;
        keybinding = "default";
        faviconService = "twenty";
        rootSearch.searchFiles = true;
        font.size = 11;
        window = {
          csd = true;
          opacity = 0.95;
          rounding = 8;
        };
      };
    };
  };
}
