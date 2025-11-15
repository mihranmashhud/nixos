{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  plugins.auto-session = {
    enable = true;
    settings = {
      use_git_branch = true;
    };
  };
}
