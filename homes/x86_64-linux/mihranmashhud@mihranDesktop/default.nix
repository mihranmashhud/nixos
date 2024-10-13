{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.
  config,
  ...
}:
with lib;
with lib.internal; {
  imports = [./hyprland.nix];
  internal.apps = enabled;
  programs.ags = {
    enable = true;
    extraPackages = with inputs.ags.packages.${target}; [
      apps
      battery
      bluetooth
      hyprland
      mpris
      network
      notifd
      tray
      wireplumber
    ];
  };
  home.packages = [
    inputs.ags.packages.${target}.astal
  ];
}
