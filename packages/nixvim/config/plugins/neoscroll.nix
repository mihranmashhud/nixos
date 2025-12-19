{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  # TODO: replace with Snacks' scroll
  plugins.neoscroll = {
    enable = true;
  };
}
