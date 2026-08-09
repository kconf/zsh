# vim:foldmethod=marker

#: Core {{{
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
# Set the default Less options.
export LESS='-F -g -i -M -R -S -w -X'

cdpath+=($HOME)
#: }}}

#: History {{{
HISTSIZE=10000
SAVEHIST=10000

HISTFILE="$HOME/.zsh_history"

setopt HIST_FCNTL_LOCK           # Use fcntl() locks to ensure that only one shell writes the history file at a time.

# NOTE: Ignoring all duplicates will cause the history to be out of order
# setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.

# This option will add a timestamp to each history entry.
setopt SHARE_HISTORY             # Share history between all sessions.
#: }}}

#: User scripts {{{
for env_file in $HOME/.zsh.d/*.sh(-.N); do
  source $env_file
done
unset env_file
#: }}}

#: Aliases {{{
alias e='nvim'
alias g='git'
alias hx='helix'
alias ls='ls --color=auto'
alias lt='eza --tree'
alias la='eza -a'
alias ll='eza -l'
alias lla='eza -la'
alias o='xdg-open'
#: }}}

#: Autocomplete {{{
fpath+=($HOME/.zfunc)  # Add custom completions to fpath

autoload -Uz compinit && compinit

zstyle ':completion:*' menu no          # select: 使用菜单选择补全项 / no: 只列出选项不选择
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # 颜色支持
zstyle ':completion:*' group-name ''       # 对补全项分组
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # 不区分大小写

# Settings for fzf-tab
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
#: }}}

#: Plugins {{{
eval "$(sheldon source)"

eval "$(starship init zsh)"

eval "$(zoxide init zsh )"

eval "$(fzf --zsh)"

eval "$(mise activate zsh)"
#: }}}
