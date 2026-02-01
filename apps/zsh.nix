{ pkgs, ... }:

{
  # Включаем Zsh.
  programs.zsh = {
    enable = true;

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      gemini = "npx @google/gemini-cli";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
      "SHARE_HISTORY"
      "EXTENDED_HISTORY"
    ];

    shellInit = ''
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';

    interactiveShellInit = ''
      fpath+=('${pkgs.zsh-completions}/share/zsh/site-functions')
      autoload -Uz compinit
      compinit -i
    '';
  };


  # Пакеты для улучшения работы с Zsh.
  # Они будут доступны всем пользователям, у которых shell - zsh.
  environment.systemPackages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    zsh-fzf-history-search
    zsh-fzf-tab
    zsh-powerlevel10k
    meslo-lgs-nf
    fzf
  ];
}
