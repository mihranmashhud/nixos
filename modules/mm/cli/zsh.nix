{lib, ...}: {
  mm.cli.zsh.homeManager = {
    pkgs,
    config,
    ...
  }: {
    home.packages = with pkgs; [
      rmtrash
    ];
    programs.zsh = {
      enable = true;

      autocd = true;
      dotDir = "${config.xdg.configHome}/zsh";
      shellAliases =
        lib.optionalAttrs config.programs.eza.enable {
          ls = "eza";
        }
        // lib.optionalAttrs config.programs.bat.enable {
          cat = "bat";
        }
        // lib.optionalAttrs config.programs.zoxide.enable {
          cd = "z";
        }
        // {
          rm = "rmtrash";
          rmdir = "rmdirtrash";
        };

      # Load completion before loading plugins with antidote.
      initContent =
        lib.mkBefore
        # bash
        ''
          autoload -U compinit && compinit
        '';
      enableCompletion = false;

      antidote = {
        enable = true;
        plugins = [
          "ohmyzsh/ohmyzsh path:lib/completion.zsh"
          "ohmyzsh/ohmyzsh path:plugins/gitfast"
          "ohmyzsh/ohmyzsh path:plugins/wd"
          "ohmyzsh/ohmyzsh path:plugins/compleat"
          "ohmyzsh/ohmyzsh path:plugins/pip"
          "ohmyzsh/ohmyzsh path:plugins/npm"
          "ohmyzsh/ohmyzsh path:plugins/history"
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting"
          "ael-code/zsh-colored-man-pages"
          "chisui/zsh-nix-shell path:nix-shell.plugin.zsh"
        ];
      };
    };
  };
}
