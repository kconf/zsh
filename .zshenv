# vim:foldmethod=marker

# See: https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html
# .zshenv is sourced on all invocations of the shell, unless the -f option is set.
# It should contain commands to set the command search path, plus other important environment variables.

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

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi
