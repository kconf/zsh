# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# region History
#

HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
#
# endregion History
#

#
# region File navigation
#
cdpath=(
  $HOME
  $cdpath
)

if [[ -d $HOME/.zfunc ]]; then
  fpath+=($HOME/.zfunc)
fi

setopt AUTO_CD                  # Use the shorthand ~/Downloads for cd ~/Downloads.
setopt CDABLE_VARS              # Change directory to a path stored in a variable.
setopt AUTO_PUSHD               # Keep a directory stack of all the directories you cd to in a session.
setopt PUSHD_IGNORE_DUPS        # Do not store duplicates in the stack.
setopt PUSHD_SILENT             # Do not print the directory stack after pushd or popd.
setopt PUSHD_MINUS              # Use Git-like -N instead of the default +N (e.g. cd -2 as opposed to cd +2).
setopt EXTENDED_GLOB            # Use extended globbing syntax.
#
# endregion File navigation
#

#
# region Keybinding
#
bindkey -v
export KEYTIMEOUT=1

# edit current command line with vim (vim-mode, then v)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
#
# endregion Keybinding
#

#
# region Completion
#

# Should be called before compinit
zmodload zsh/complist

# Use hjlk in menu selection (during completion)
# Doesn't work well with interactive mode
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xi' vi-insert                      # Insert
bindkey -M menuselect '^xh' accept-and-hold                # Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
bindkey -M menuselect '^xu' undo                           # Undo

# Options
setopt COMPLETE_IN_WORD         # Tries to complete in the word at the point of the cursor
setopt PATH_DIRS                # Perform path search even on command names with slashes.
setopt ALWAYS_TO_END            # Move the cursor to the end of the word after accepting a completion.
setopt LIST_PACKED              # The completion menu takes less space.

# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# Allow you to select in a menu
zstyle ':completion:*' menu select
zstyle ':completion:*' file-sort modification

# Partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

export LS_COLORS=${LS_COLORS:-di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:}
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

#
# endregion Completion
#

#
# region Packages
#

# Setup zinit
# https://github.com/zdharma-continuum/zinit
export ZINIT_HOME=$HOME/.zinit
if [[ ! -d $ZINIT_HOME/bin/.git ]]; then
  mkdir -p $ZINIT_HOME
  git clone https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME/bin
fi
source $ZINIT_HOME/bin/zinit.zsh

zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zstyle ":history-search-multi-word" page-size "11"
zinit ice wait"1" lucid
zinit load zdharma-continuum/history-search-multi-word

zinit light romkatv/powerlevel10k

zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait lucid
zinit light agkozak/zsh-z

zinit ice wait lucid pick"init.zsh" atload"zicdreplay"
zinit light $HOME/.env.d
#
# endregion Packages
#

# direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
