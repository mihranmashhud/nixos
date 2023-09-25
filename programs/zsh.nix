{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;

    autocd = true;
    dotDir = ".config/zsh";
    shellAliases = {
      rm = "rmtrash";
      rmdir = "rmdirtrash";
      sudo = "sudo ";
      ls = "eza";
      cat = "bat";
    };

    # Load completion before loading plugins with antidote.
    initExtraFirst = "autoload -U compinit && compinit";
    enableCompletion = false;

    antidote = {
      enable = true;
      plugins = [
        # Completion
        "ohmyzsh/ohmyzsh path:lib/completion.zsh"

        # Plugins
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
      ];
    };
  };
}
