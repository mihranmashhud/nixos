{
  mm.apps._1password = {
    nixos = {
      environment.etc = {
        "1password/custom_allowed_browsers" = {
          text = ''
            zen-beta
          '';
          mode = "0755";
        };
      };
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
      };
    };
    provides.to-users = {user, ...}: {
      nixos = {
        programs._1password-gui = {
          polkitPolicyOwners = [user.name];
        };
      };
    };
  };
}
