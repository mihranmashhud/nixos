{
  lib,
  namespace,
  inputs,
  pkgs,
  config,
  ...
}: {
  plugins.transparent = {
    enable = true;
    settings.extra_groups = [
      "NormalFloat"
      "TelescopeBorder"
      "FloatermBorder"
      "WhichKeyBorder"
      "FloatBorder"
    ];
  };
}
