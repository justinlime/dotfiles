# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
setopt PROMPT_SUBST
PROMPT='%B%F{183}%m%f%F{111}[%f%F{158}%~%f%F{111}]%f%F{111}$(parse_git_branch)%f %F{183}>%f%f%b '
# End of lines configured by zsh-newuser-install
