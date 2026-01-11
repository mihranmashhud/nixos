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
  cfg = config.${namespace}.gaming.steam;
in {
  options.${namespace}.gaming.steam = {
    enable = mkBoolOpt false "Whether to enable steam configuration.";
  };
  config = mkIf cfg.enable {
      
    environment.systemPackages = with pkgs; [
      # Currently broken: waiting for PR: https://github.com/NixOS/nixpkgs/pull/475718 to fix it.
      # sgdboop
    ];
    hardware.graphics.enable32Bit = true;
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
    ${namespace}.user.extraGroups = ["gamemode"];
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
      extest.enable = true;
      protontricks.enable = true;
      platformOptimizations.enable = true;
      gamescopeSession.enable = true;
    };
  };
}
