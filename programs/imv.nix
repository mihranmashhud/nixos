{
  config,
  pkgs,
  ...
}: {
  programs.imv = {
    enable = true;
    settings = {
      binds = {
        "<Return>" = "exec echo $imv_current_file; quit";
      };
    };
  };
}
