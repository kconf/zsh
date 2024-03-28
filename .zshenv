# Ensure that a non-login, non-interactive shell has a defined environment.
# .zshenv → [.zprofile if login] → [.zshrc if interactive] → [.zlogin if login] → [.zlogout sometimes]
# Zsh on Arch sources /etc/profile – which overwrites and exports PATH – after having sourced ~/.zshenv
# So we should define PATH in .zprofile
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "$HOME/.zprofile" ]]; then
  source "$HOME/.zprofile"
fi
