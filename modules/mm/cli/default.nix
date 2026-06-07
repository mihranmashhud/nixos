{
  mm,
  self,
  ...
}: {
  mm.cli = {
    includes = [
      mm.cli._
    ];
    homeManager = {
      pkgs,
      user,
      ...
    }: {
      home.packages = with pkgs;
      with self.packages.${pkgs.system}; [
        zip
        unzip
        swap
        python3
        git-credential-manager
      ];
      programs.bat.enable = true;
      programs.btop.enable = true;
      programs.eza = {
        enable = true;
        icons = "auto";
      };
      programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
      };
      programs.git = {
        enable = true;
        package = pkgs.gitFull;
        settings = {
          user = {
            name = user.name;
            email = user.email;
          };
          color.ui = "auto";
          push = {
            autoSetupRemote = true;
          };
          credential.credentialStore = "secretservice";
        };
      };
      programs.delta = {
        enable = true;
        options = {
          side-by-side = true;
        };
        enableGitIntegration = true;
      };
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
