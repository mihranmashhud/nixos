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
  cfg = config.${namespace}.apps.mako;
  system-sounds = "${pkgs.kdePackages.ocean-sound-theme}/share/sounds/ocean/stereo";
in {
  options.${namespace}.apps.mako = {
    enable = mkBoolOpt false "Whether to enable mako configuration.";
  };
  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      defaultTimeout = 2000;
      borderRadius = 5;
      borderSize = 2;
      layer = "overlay";
      extraConfig = ''
        on-button-left=exec makoctl menu -n "$id" rofi -dmenu -p 'Select action: '
        on-notify=exec mpv ${system-sounds}/message-attention.oga
      '';
    };
  };
}
