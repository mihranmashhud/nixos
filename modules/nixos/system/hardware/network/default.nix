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
  cfg = config.${namespace}.hardware.network;
in {
  options.${namespace}.hardware.network = {
    enable = mkBoolOpt false "Whether to enable network configuration.";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
    programs.nm-applet.enable = true;
    services.automatic-timezoned.enable = true;
    ${namespace}.user.extraGroups = ["networkmanager"];
  };
}
