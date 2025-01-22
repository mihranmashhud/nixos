{
  lib,
  inputs,
  namespace,
  snowfall-inputs,
}:
with lib; rec {
  modulo = number: divisor: number - divisor * (number / divisor);
  range = start: end: builtins.genList (x: x + start) (end - start);
  mkIfElse = p: yes: no:
    mkMerge [
      (mkIf p yes)
      (mkIf (!p) no)
    ];
  umport = args @ {
    path ? null,
    paths ? [],
    include ? [],
    exclude ? [],
    recursive ? true,
  }:
    with fileset; let
      excludedFiles = filter (path: pathIsRegularFile path) exclude;
      excludedDirs = filter (path: pathIsDirectory path) exclude;
      isExcluded = path:
        if elem path excludedFiles
        then true
        else (filter (excludedDir: lib.path.hasPrefix excludedDir path) excludedDirs) != [];
    in
      unique (
        (
          filter
          (file: pathIsRegularFile file && hasSuffix ".nix" (builtins.toString file) && !isExcluded file)
          (concatMap (
              _path:
                if recursive
                then toList _path
                else
                  mapAttrsToList (
                    name: type:
                      _path
                      + (
                        if type == "directory"
                        then "/${name}/default.nix"
                        else "/${name}"
                      )
                  )
                  (builtins.readDir _path)
            )
            (unique (
              if path == null
              then paths
              else [path] ++ paths
            )))
        )
        ++ (
          if recursive
          then concatMap (path: toList path) (unique include)
          else unique include
        )
      );
}
