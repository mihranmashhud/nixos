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
  cfg = config.${namespace}.hardware.printer;
in {
  options.${namespace}.hardware.printer = {
    enable = mkBoolOpt false "Whether to enable printer configuration.";
  };

  config = mkIf cfg.enable {
    # Printing
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    # for WiFi printer
    services.avahi.openFirewall = true;
    # Load epson driver
    services.printing.drivers = with pkgs; [
      epson-escpr
    ];
    # Scanning
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
    };
    environment.systemPackages = with pkgs; [
      simple-scan
    ];
  };
}
