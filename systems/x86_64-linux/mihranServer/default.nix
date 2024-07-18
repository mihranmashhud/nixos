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
    # ./hardware.nix # Make sure to add the generated hardware config.
  ];
  internal = {
    locale = enabled;
    development = {
      direnv = enabled;
      docker = enabled;
      pnpm = enabled;
      ssh = enabled;
    };
  };
}
