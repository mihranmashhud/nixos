{pkgs, ...}: let
  inherit (builtins) concatMap concatStringsSep hasAttr;
  hasAttrs = attrs: set: builtins.all (attr: hasAttr attr set) attrs;
in {
  hypr = {
    windowrules = list:
      concatMap (
        set:
          concatMap (rule: map (window: concatStringsSep "," [rule window]) set.windows) set.rules
      )
      list;
    binds = list:
      map ({
        mods ? "",
        key,
        dispatcher,
        params,
      }:
        concatStringsSep "," [mods key dispatcher params])
      list;
  };
}
