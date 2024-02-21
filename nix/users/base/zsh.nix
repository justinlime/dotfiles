{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
    eza
    fd
    zoxide
  ];
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      setopt appendhistory
      parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
      }
      setopt PROMPT_SUBST
      PROMPT='%B%F{183}%m%f%F{111}[%f%F{158}%~%f%F{111}]%f%F{111}$(parse_git_branch)%f %F{183}>%f%f%b '
			if [[ "$TERM" == "dumb" ]]
			then
				unsetopt zle
				unsetopt prompt_cr
				unsetopt prompt_subst
				unfunction precmd
				unfunction preexec
				PS1='$ '
			fi
      function cd() {
          if which eza >/dev/null; then 
              if [ $# -eq 0 ]; then
                  builtin cd && eza --group-directories-first
              else
                  builtin cd "$@" && eza --group-directories-first
              fi
          else
              if [ $# -eq 0 ]; then
                builtin cd && ls --group-directories-first
              else
                  builtin cd "$@" && ls --group-directories-first
              fi
          fi
      }
      function f(){
         builtin cd "$(fd -t d --full-path / . | fzf)" && eza --group-directories-first
      }
      function fa(){
         builtin cd "$(fd -t d --full-path / / | fzf)" && eza --group-directories-first
      }
      function fh(){
         builtin cd "$(fd -t d --full-path / ~ | fzf)" && eza --group-directories-first
      }
    '' +
    # Nix Specific
    ''
      export PATH=$HOME/.nix-profile/bin:$PATH
      export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
      eval "$(zoxide init --cmd z zsh)"
      function cd() {
         if [ $# -eq 0 ]; then
            z && eza --group-directories-first
         else
            z "$@" && eza --group-directories-first
         fi
      }
    '';
  };
}
