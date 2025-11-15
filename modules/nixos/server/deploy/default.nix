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
  cfg = config.${namespace}.server.deploy;
in {
  options.${namespace}.server.deploy = with types; {
    enable = mkEnableOption "Remote deploy-rs";
    keys = mkOpt (listOf str) [] "List of public keys authorized for ssh deployment via the 'deploy' user.";
  };

  config = mkIf cfg.enable {
    users.users.deploy = {
      isNormalUser = true;
      description = "System deploy user";
      uid = 2000;
      extraGroups = [
        "wheel"
        "sudo"
      ];
      openssh.authorizedKeys.keys = cfg.keys;
    };
    security.pam.sshAgentAuth.enable = true; # Required for deploy
    security.sudo.extraRules = [
      {
        users = ["deploy"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
    nix.settings.trusted-users = ["deploy"];
  };
}
