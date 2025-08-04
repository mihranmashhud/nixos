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
  cfg = config.${namespace}.cli.zsh;
in {
  options.${namespace}.cli.zsh = {
    enable = mkBoolOpt false "Whether to enable zsh configuration.";
  };
  config = mkIf cfg.enable {
    programs.command-not-found = enabled;
    programs.zsh = {
      enable = true;

      autocd = true;
      dotDir = "${config.xdg.configHome}/zsh";
      shellAliases =
        optionalAttrs config.${namespace}.cli.eza.enable {
          ls = "eza";
        }
        // optionalAttrs config.${namespace}.cli.bat.enable {
          cat = "bat";
        }
        // optionalAttrs config.${namespace}.cli.zoxide.enable {
          cd = "z";
        }
        // optionalAttrs config.${namespace}.cli.trash-cli.enable {
          rm = "rmtrash";
          rmdir = "rmdirtrash";
        };

      # Load completion before loading plugins with antidote.
      initContent =
        lib.mkBefore
        /*
        bash
        */
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
          "ohmyzsh/ohmyzsh path:plugins/command-not-found"
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
