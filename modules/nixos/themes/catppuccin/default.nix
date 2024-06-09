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
  cfg = config.${namespace}.themes.catppuccin;
in {
  options.${namespace}.themes.catppuccin = with types; {
    enable = mkBoolOpt false "Whether to enable catppuccin system theme";
  };

  config = mkIf cfg.enable {
    stylix = {
      autoEnable = false;
      polarity = "dark";
      base16Scheme = getScheme pkgs "catppuccin-mocha";
      opacity.terminal = 0.8;
    };

    stylix.cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
    };
    boot.plymouth.enable = true;
    services.displayManager.sddm.package = pkgs.kdePackages.sddm;
  };
}
