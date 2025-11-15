{
  lib,
  inputs,
  namespace,
  pkgs,
  ...
}: let
  system = pkgs.system;
  nixvim = inputs.nixvim.legacyPackages.${system};
  nixvimModule = {
    module = import ./config;
    extraSpecialArgs = {
      inherit inputs namespace;
    };
  };
in
  nixvim.makeNixvimWithModule nixvimModule
