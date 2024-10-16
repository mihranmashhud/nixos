{
  lib,
  pkgs,
  inputs,
  system,
  config,
  ...
}:
with lib;
with lib.internal; {
  imports = [
    ./hardware.nix
  ];

  internal = {
    system = enabled;

    gaming = enabled;
    development = enabled;

    desktop.hyprland = enabled;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.upower.enable = true;
  services.libinput.enable = true; # Enable touchpad support
  services.tlp.enable = true;

  # Distributed Nix builds
  nix.buildMachines = [{
    hostName = "builder";
    system = "x86_64-linux";
    protocol = "ssh-ng";
    maxJobs = 3;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
  }];
  nix.distributedBuilds = true;
  nix.settings = {
    builders-use-substitutes = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
