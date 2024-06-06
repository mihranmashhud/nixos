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
  cfg = config.${namespace}.suites.development;
in {
  options.${namespace}.suites.development = {
    enable = mkBoolOpt false "Whether to enable the development suite.";
    withGui = mkBoolOpt true "Should gui apps be included.";
  };
  config = mkIf cfg.enable {
    ${namespace} = {
      cli = {
        bat = enabled;
        eza = enabled;
        git = enabled;
        neovim = enabled;
        ssh-agent = enabled;
        starship = enabled;
        trash-cli = enabled;
        zoxide = enabled;
        zsh = enabled;
      };
      development = {
        postgres = enabled;
        adb = enabled;
        direnv = enabled;
        pnpm = enabled;
        docker = enabled;
      };

      apps.development.enable = cfg.withGui;
    };
  };
}
