# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../shared.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "mihranDesktop"; # Define your hostname.
  networking.interfaces.enp4s0.wakeOnLan = {
    enable = true;
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Monitors listing
  services.xserver.xrandrHeads = [
    "DP-1"
    "HDMI-A-1"
  ];

  # Enable AMDVLK
  hardware.amdgpu.amdvlk = true;

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
}
