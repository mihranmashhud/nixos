{
  lib,
  inputs,
  namespace,
  snowfall-inputs,
}:
with lib; rec {
  vim = {
    fromGitHub = {
      rev,
      owner,
      repo,
      hash,
      pkgs,
    }:
      pkgs.vimUtils.buildVimPlugin {
        pname = "${lib.strings.sanitizeDerivationName repo}";
        version = rev;
        src = pkgs.fetchFromGitHub {
          inherit rev;
          inherit owner;
          inherit repo;
          inherit hash;
        };
      };
  };
}
