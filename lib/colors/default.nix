{
  lib,
  inputs,
  namespace,
  snowfall-inputs,
}:
with lib; rec {
  getScheme = pkgs: scheme: "${pkgs.base16-schemes}/share/themes/${scheme}.yaml";
}
