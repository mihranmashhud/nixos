{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  plugins.fidget = {
    enable = true;
    settings = {
      notification.window.winblend = 0;
    };
  };
}
