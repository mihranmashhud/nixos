# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../shared.nix
      ./hardware-configuration.nix
    ];
  networking.hostName = "mihranDesktop"; # Define your hostname.

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  boot.initrd.kernelModules = [
    "amdgpu"
  ];
}
