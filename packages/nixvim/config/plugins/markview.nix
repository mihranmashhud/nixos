{
  lib,
  namespace,
  inputs,
  pkgs,
  config,
  ...
}: {
  plugins.markview = {
    enable = true;
  };
}
