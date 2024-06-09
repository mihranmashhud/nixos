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

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  internal = {
    system = enabled;

    gaming = enabled;
    development = enabled;

    desktop.hyprland = enabled;
  };

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    sidequest
    r2modman
    gkraken
  ];

  networking.interfaces.enp4s0.wakeOnLan = {
    enable = true;
  };

  programs.alvr = {
    enable = true;
    package = pkgs.internal.alvr;
    openFirewall = true;
  };

  # Enable AMDVLK
  hardware.amdgpu.amdvlk = true;

  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  services.pipewire.lowLatency = {
    enable = true;
    quantum = 32;
    rate = 48000;
  };
  security.rtkit = enabled;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
