{
  lib,
  inputs,
  namespace,
  snowfall-inputs,
}:
with lib; rec {
  hypr = {
    windowrules = list:
      concatMap (
        set:
          concatMap (rule: map (window: concatStringsSep "," [rule window]) set.windows) set.rules
      )
      list;
  };
}
