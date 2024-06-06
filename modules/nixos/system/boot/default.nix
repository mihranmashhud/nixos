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
  cfg = config.${namespace}.boot;
in {
  options.${namespace}.boot = {
    enable = mkBoolOpt false "Whether to enable boot configuration.";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
        grub = {
          enable = true;
          copyKernels = true;
          device = "nodev";
          efiSupport = true;
          configurationLimit = 5;
          useOSProber = true;
        };
        timeout = 10;
      };
      kernelParams =
        if config.boot.plymouth.enable
        then [
          # Silent Boot Params
          "quiet"
          "splash" # See splash screen
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
          "boot.shell_on_fail"
        ]
        else [];
    };
  };
}
