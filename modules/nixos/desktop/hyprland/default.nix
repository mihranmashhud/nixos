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
  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether to enable hyprland system configuration.";
  };

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;
    services.displayManager = {
      sddm.wayland.enable = true;
      sddm.enable = true;
    };

    ${namespace} = {
      nix.extra-substituters = [
        {
          url = "https://hyprland.cachix.org";
          key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
        }
      ];
      polkit = enabled;
    };
  };
}
