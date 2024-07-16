# vim:foldmethod=marker

#: Core {{{
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
# Set the default Less options.
export LESS='-F -g -i -M -R -S -w -X -z-4'

cdpath+=($HOME)
#: }}}

#: History {{{
HISTSIZE=10000
SAVEHIST=10000

HISTFILE="$HOME/.zsh_history"
mkdir -p $(dirname $HISTFILE)

setopt HIST_FCNTL_LOCK           # Use fcntl() locks to ensure that only one shell writes the history file at a time.

# NOTE: Ignoring all duplicates will cause the history to be out of order
# setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.

# This option will add a timestamp to each history entry.
# setopt SHARE_HISTORY             # Share history between all sessions.
#: }}}

#: User scripts {{{
for env_file in $HOME/.zsh.d/*.sh(-.N); do
  source $env_file
done
unset env_file
#: }}}

#: Aliases {{{
alias e='nvim'
alias f='nnn -a'
alias g='git'
alias la='eza -a'
alias ll='eza -l'
alias lla='eza -la'
alias ls='eza'
alias lt='eza --tree'
alias o='xdg-open'
alias rm='echo "This is not the command you are looking for."; false'
#: }}}

#: Plugins {{{
eval "$(sheldon source)"

if [[ $TERM != "dumb" ]]; then
  eval "$(starship init zsh)"
fi

eval "$(zoxide init zsh )"

if [[ $options[zle] = on ]]; then
  eval "$(fzf --zsh)"
fi
#: }}}
