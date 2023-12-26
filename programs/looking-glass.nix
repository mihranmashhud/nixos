{
  config,
  pkgs,
  ...
}: {
  programs.looking-glass-client = {
    enable = true;
  };
}
