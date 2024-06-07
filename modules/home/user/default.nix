{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  name = config.snowfallorg.user.name;
  cfg = config.${namespace}.user;
  defaultIconFileName = "profile.png";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ../../../assets + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = {fileName = defaultIconFileName;};
  };
  propagatedIcon =
    pkgs.runCommandNoCC "propagated-icon"
    {passthru = {fileName = cfg.icon.fileName;};}
    ''
      local target="$out/share/internal-icons/user/${cfg.name}"
      mkdir -p "$target"

      cp ${cfg.icon} "$target/${cfg.icon.fileName}"
    '';
in {
  options.${namespace}.user = with types; {
    name = mkOpt str name "The name to use for the user account.";
    fullName = mkOpt str "Mihran Mashhud" "The full name of the user.";
    email = mkOpt str "mihranmashhud@gmail.com" "The email of the user.";
    icon =
      mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";
  };

  config = {
    home.packages = with pkgs; [
      propagatedIcon
    ];

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      history.path = "$XDG_CACHE_HOME/zsh.history";
    };

    home.username = cfg.name;
    home.file = {
      ".face".source = defaultIcon;
    };
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
      };
    };
  };
}
