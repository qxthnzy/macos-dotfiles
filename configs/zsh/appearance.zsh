# Source from ~/.zshrc in place of the existing Oh My Zsh initialization.
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME="robbyrussell"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# Use the current directory's basename for terminal tab titles.
case "$TERM" in
  xterm*|rxvt*|kitty)
    precmd() { print -rn -- $'\e]0;'${PWD##*/}$'\a' }
    ;;
esac
