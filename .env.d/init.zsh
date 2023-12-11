#!/bin/zsh -f
#
# Useful aliases and tools
#

# List files
if (( $+commands[lsd] )); then
  alias ls=lsd
elif (( $+commands[exa] )); then
  alias ls=exa
else
  case "$OSTYPE" in
    darwin*|freebsd* )
      alias ls='ls -G'
      ;;
    linux* )
      alias ls='ls --color=auto'
      ;;
  esac
fi

alias l=ls
alias ll='ls -lh'
alias la='ls -a'

# Fuzzy finder
if (( $+commands[fzf] )); then
  case "$OSTYPE" in
    darwin*)
      source "/usr/local/opt/fzf/shell/completion.zsh"
      source "/usr/local/opt/fzf/shell/key-bindings.zsh"
      ;;
    linux*)
      source "/usr/share/fzf/completion.zsh"
      source "/usr/share/fzf/key-bindings.zsh"
      ;;
  esac

  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  alias f='fzf-tmux -r 60%'
  alias fp='f --height=70% --preview="head -80 {}" --preview-window=right:60%:wrap'
fi

zz() {
  cd $(z -l $@ | awk '{print $2}' | f)
}

# Git
alias g=git

# Editors
e() {
  zparseopts -D t=o_tty

  if [[ $o_tty == '-t' || ! -v DISPLAY ]]; then
    emacsclient -t "$@"
  else
    if (( $(emacsclient -n -e "(length (frame-list))") > 1 )); then
      emacsclient -nq "$@" &> /dev/null
    else
      emacsclient -nqc "$@" &> /dev/null
    fi
  fi
}

alias et='e -t'
alias v=vim
alias n=nvim

# Proxy using clash
p() {
  local http_port=7890
  local socks_port=1089
  if (( $# == 0 )); then
    unset http_proxy https_proxy all_proxy no_proxy GIT_SSH_COMMAND
  else
    export http_proxy=http://$1:$http_port https_proxy=http://$1:$http_port all_proxy=socks5://$1:$socks_port
    export no_proxy="localhost,*.local,127.0.0.1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,::1,fe80::/10"
    export GIT_SSH_COMMAND="ssh -o 'ProxyCommand=nc -x $1:$socks_port %h %p'"
  fi
  env | grep proxy
}

_p() {
  _arguments '1: :(localhost n1)'
}
compdef _p p

setup-proxy() {
    networksetup -setwebproxy "Wi-fi" 127.0.0.1 8889
    networksetup -setsecurewebproxy "Wi-fi" 127.0.0.1 8889
}

ppp() {
    local e=$(networksetup -getwebproxy wi-fi | grep "No")

    local ns=wi-fi
    local st=''
    if [ -n "$e" ]; then
      st=on
    else
      st=off
    fi

    echo "Turning $st proxy"
    networksetup -setstreamingproxystate $ns $st
    networksetup -setsocksfirewallproxystate $ns $st
    networksetup -setwebproxystate $ns $st
    networksetup -setsecurewebproxystate  $ns $st
}

# Config management
c() {
  if (( $# < 2 )); then
    echo "Usage: $0 <diff|backup|update> pkg"
    return
  fi

  local act=$1
  local pkg=$2
  local cfg=$HOME/setup/roles/$pkg/files

  if [[ ! -d $cfg ]]; then
    echo "No files for $pkg"
    return
  fi

  pushd -q $cfg
  local files=($(rg --hidden --files))

  if [[ $act == diff ]]; then
    for f in ${files[@]}; do
      if [[ -e $HOME/$f ]]; then
        git diff --no-index -w $cfg/$f $HOME/$f
      else
        echo "$HOME/$f \e[31mX\e[m"
      fi
    done
  elif [[ $act == backup ]]; then
    for f in ${files[@]}; do
      if [[ -e $HOME/$f ]]; then
        cp $HOME/$f $cfg/$f
      fi
    done
  elif [[ $act == update ]]; then
    for f in ${files[@]}; do
      cp $cfg/$f $HOME/$f
    done
  else
    echo "Usage: $0 <diff|backup|update> [pkg]"
  fi

  popd -q
}

_c() {
  local state
  _arguments '1: :(diff backup update)' '2: :->pkg'

  if [[ $state == pkg ]]; then
    _describe 'command' "($(ls $HOME/setup/roles))"
  fi
}

compdef _c c

# http server
alias s='python3 -m http.server & open http://localhost:8000 && fg'

# Disk
d() {
  local f=${1:-$PWD}
  local depth=${2:-0}
  du -d $depth -h $f | sort -rh
}

# Cheat sheet
alias cs='open $(find $HOME/cheatsheets -type f|fzf)'

# Open
case "$OSTYPE" in
  darwin*)
    alias o=open
    ;;
  linux*)
    alias o=xdg-open
    ;;
esac

for f in $HOME/.env.d/*.plugin.zsh(-.N); do
  source $f
done
unset f

# Kitty
alias kk='kitty +kitten'
# Ranger
alias rr=ranger
# Label me
lm() {
    labelme $1 -O ${1:r}.json
}

# Pandoc
pd() {
    local tmpl=${2:-pdf}
    local fmt=${tmpl:r}
    local defaults=$HOME/.config/pandoc/defaults/${tmpl}.yaml
    local opts=()
    if [[ -f $defaults ]]; then
        opts+=(-d $defaults)
    fi
    if [[ $fmt = docx && -f reference.docx ]]; then
        opts+=(--reference-doc=reference.docx)
    fi
    echo pandoc $opts $1 -o ${1:r}.${fmt}
    pandoc $opts $1 -o ${1:r}.${fmt}
}

# Patch Android Studio to avoid case-sensitive warning
alias intellij-case-patch='printf '\''\nidea.case.sensitive.fs=true'\'' >> /Applications/Android\ Studio.app/Contents/bin/idea.properties'

# vcsh helper
vcsh2mr() {
    local pkg=$1
    echo "[\$HOME/.config/vcsh/repo.d/$pkg.git]"
    echo "checkout = vcsh clone 'https://github.com/kconf/$pkg.git' '$pkg'"
    echo "update   = vcsh $pkg pull"
    echo "push     = vcsh $pkg push"
    echo "status   = vcsh $pkg status"
    echo "gc       = vcsh $pkg gc"
}

vcshremote() {
    vcsh $1 remote add -f origin git@github.com:kconf/$1.git
}

