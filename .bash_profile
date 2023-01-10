# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

export TERM=linux

export PS1="\[\e[1m\]\[\033[38;5;183m\]\h\[$(tput sgr0)\]\[\e[1m\]\[\033[38;5;81m\][\[$(tput sgr0)\]\[\e[1m\]\[\033[38;5;157m\]\w\[$(tput sgr0)\]\[\e[1m\]\[\033[38;5;81m\]]\[$(tput sgr0)\] \[$(tput sgr0)\]\[
\e[1m\]\[\033[38;5;183m\]>\[$(tput sgr0)\] \[$(tput sgr0)\]"

# User specific environment and startup programs
