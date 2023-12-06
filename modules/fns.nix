{pkgs, ...}: let
  inherit (builtins) concatMap concatString;
in {
  hypr = {
    windowrules = list:
      concatMap ({
        window,
        rules,
      }:
        map (rule: "${rule},${window}") rules)
      list;
    binds = list:
      map ({
        mods ? "",
        key,
        dispatcher,
        params,
      }:
        concatString "," [mods key dispatcher params])
      list;
  };
}
