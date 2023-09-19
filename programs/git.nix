{ config, pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "mihranmashhud";
    userEmail = "mihranmashhud@gmail.com";
  };
}
