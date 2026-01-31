{ pkgs, ... }:

{
  # Включаем Zsh.
  #programs.zsh.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
  };

  # Пакеты для улучшения работы с Zsh.
  # Они будут доступны всем пользователям, у которых shell - zsh.
  environment.systemPackages = with pkgs; [
    zsh
#     zsh-autosuggestions
#     zsh-syntax-highlighting
#     zsh-completions
#     zsh-fzf-history-search
#     zsh-fzf-tab
#     zsh-powerlevel10k
#     oh-my-zsh
    meslo-lgs-nf
    fzf
  ];
}
