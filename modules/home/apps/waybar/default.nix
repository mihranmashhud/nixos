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
  cfg = config.${namespace}.apps.waybar;
in {
  options.${namespace}.apps.waybar = {
    enable = mkBoolOpt false "Whether to enable waybar configuration.";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dualsensectl
    ];
    xdg.configFile."waybar/modules.json".source = ./config/modules.json;
    xdg.configFile."waybar/desktop-config.json".source = ./config/desktop-config.json;
    xdg.configFile."waybar/laptop-config.json".source = ./config/laptop-config.json;
    xdg.configFile."waybar/style.css".source = mkForce ./config/style.css;
    programs.waybar = {
      enable = true;
      package = inputs.waybar.packages.${system}.waybar;
    };
  };
}
