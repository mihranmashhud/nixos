{mm, ...}: {
  mm.dev = {
    includes = [
      mm.dev._
    ];

    android.nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        android-tools
      ];
    };

    ai = {
      homeManager = {
        programs.opencode = {
          enable = true;
        };
      };
    };

    docker = {
      nixos = {
        virtualisation.docker.enable = true;
      };
      provides.to-users = {user, ...}: {
        nixos.users.users.${user.name}.extraGroups = ["docker"];
      };
    };

    js.nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        pnpm
        nodejs
      ];
    };

    devenv = {
      nixos = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
          devenv
        ];
      };
      homeManager = {
        programs.zsh.initContent =
          # bash
          ''
            eval "$(devenv hook zsh)"
          '';
      };
    };

    # direnv.nixos = {
    #   programs.direnv = {
    #     enable = true;
    #     silent = true;
    #   };
    # };

    postgres.nixos = {pkgs, ...}: {
      services.pgadmin = {
        enable = true;
        initialEmail = "mihranmashhud@gmail.com";
        initialPasswordFile = "/home/mihranmashhud/.pgadmin/initial_password";
        openFirewall = true;
      };
      services.postgresql = {
        enable = true;
        authentication = pkgs.lib.mkOverride 10 ''
          #type database  DBuser  auth-method
          local all       all     trust
          #type database DBuser origin-address auth-method
          # ipv4
          host  all      all     127.0.0.1/32   trust
        '';
      };
    };

    ssh.nixos = {
      programs.ssh.startAgent = true;
      services.openssh = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
