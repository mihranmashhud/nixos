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
  cfg = config.${namespace}.themes.catppuccin.fonts;
in {
  options.${namespace}.themes.catppuccin.fonts = with types; {
    enable = mkBoolOpt config.${namespace}.themes.catppuccin.enable "Whether to enable catppuccin font theming";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Hasklig"
          "Iosevka"
          "VictorMono"
        ];
      })
    ];
    stylix.fonts = {
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 12;
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.roboto-slab;
        name = "Roboto Slab";
      };
      monospace = {
        package = pkgs.nerdfonts.override {
          fonts = [
            "CascadiaCode"
          ];
        };
        name = "CaskaydiaCove Nerd Font";
      };
    };
  };
}
