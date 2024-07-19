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
    ./hardware.nix # Make sure to add the generated hardware config.
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  internal = {
    locale = enabled;
    development = {
      direnv = enabled;
      docker = enabled;
      pnpm = enabled;
      ssh = enabled;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
