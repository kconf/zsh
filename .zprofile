#
# Defines environment variables.
#

# Browser (Default)
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Less
# Set the default Less options.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Paths
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/.local/bin
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}
  /{bin,sbin}
  $path
)

if [[ -d $HOME/bin ]]; then
  path+=($HOME/bin)
fi

# User defined env
for env_file in $HOME/.env.d/*.env(-.N); do
  source $env_file
done
unset env_file

# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1
