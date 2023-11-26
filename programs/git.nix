{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    userName = "mihranmashhud";
    userEmail = "mihranmashhud@gmail.com";

    extraConfig = {
      color.ui = "auto";
      diff.tool = "nvim -d";
    };

    delta.enable = true;
  };
}
