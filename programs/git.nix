{ config, pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "mihranmashhud";
    userEmail = "mihranmashhud@gmail.com";

    extraConfig = {
      color.ui = "auto";
    };

    delta.enable = true;
  };
}
