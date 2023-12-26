{ ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      setopt appendhistory
      export PATH=$HOME/.nix-profile/bin:$PATH
      export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
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
    '';
  };
}
