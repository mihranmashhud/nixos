{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}:
let
  plugins = let 
    filenames = builtins.attrNames (builtins.readDir ./plugins);
    filtered = builtins.filter (f: lib.strings.hasSuffix ".nix" f) filenames;
    paths = map (f: ./plugins/${f}) filtered;
  in paths;
in
{
  imports = [
    ./keymaps.nix
    ./settings.nix
    ./commands.nix
    ./colorschemes.nix
  ]
  ++ plugins;
  enableMan = false;
}
