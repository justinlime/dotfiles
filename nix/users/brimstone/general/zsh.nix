{ ... }:
{
    programs.zsh = {
        enable = true;
        autocd = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        # this shit doesnt fuggin work
        # dotDir = ".config/zsh";
        # history.path = ".config/zsh/.zsh_history";
        initExtra = ''
        setopt appendhistory
        parse_git_branch() {
          git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
        }
        setopt PROMPT_SUBST
        PROMPT='%B%F{183}%m%f%F{111}[%f%F{158}%~%f%F{111}]%f%F{111}$(parse_git_branch)%f %F{183}>%f%f%b '
        '';
    };
}
