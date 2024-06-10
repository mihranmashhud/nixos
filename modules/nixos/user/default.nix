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
    name = mkOpt str "mihranmashhud" "The name to use for the user account.";
    fullName = mkOpt str "Mihran Mashhud" "The full name of the user.";
    initialPassword =
      mkOpt str "password"
      "The initial password to use when the user is first created.";
    icon =
      mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";
    uid = mkOpt int 1000 "The user ID.";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions =
      mkOpt attrs {}
      (mdDoc "Extra options passed to `users.users.<name>`. (options already declared will be overidden)");
  };

  config = {
    environment.systemPackages = with pkgs; [
      propagatedIcon

      # Always have the ability to pull files
      git
      curl
      wget

      killall
    ];

    programs.zsh.enable = true;

    users.users.${cfg.name} =
      {
        isNormalUser = true;
        description = cfg.fullName;
        shell = pkgs.zsh;
        uid = cfg.uid;
        inherit (cfg) name initialPassword extraGroups;
      }
      // cfg.extraOptions;
  };
}
