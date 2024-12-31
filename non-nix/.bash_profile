# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
export HISTSIZE=10000
export HISTFILESIZE=10000
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*; do
                if [ -f "$rc" ]; then
                        . "$rc"
                fi
        done
fi

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[\e[1m\]\[\033[38;5;183m\]\h\[$(tput sgr0)\]\[\e[1m\]\[\033[38;5;81m\][\[$(tput sgr0)\]\[\e[1m\]\[\033[38;5;157m\]\w\[$(tput sgr0)\]\[\e[1m\]\[\033[38;5;81m\]]\[$(tput sgr0)\]\[\e[1m\]\[\033[38;5;81m\]\$(parse_git_branch) \[$(tput sgr0)\]\[\e[1m\]\[\033[38;5;183m\]>\[$(tput sgr0)\] \[$(tput sgr0)\]"

unset rc

