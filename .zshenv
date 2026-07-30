# vim:foldmethod=marker

# See: https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html
# .zshenv is sourced on all invocations of the shell, unless the -f option is set.
# It should contain commands to set the command search path, plus other important environment variables.

# .zshenv runs for every zsh, including child shells.  `-U` makes these arrays
# unique, so repeatedly sourcing this file (or .zshrc) remains idempotent.
typeset -gU path cdpath fpath mailpath

# Keep command-search paths available to both interactive and non-interactive
# zsh processes.  Entries here take precedence over inherited PATH entries.
path=(
  $HOME/.local/bin
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}
  /{bin,sbin}
  $path
)

export LANG="${LANG:-en_US.UTF-8}"
