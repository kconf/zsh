#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm zsh fzf zoxide starship eza bat ripgrep zellij fd sheldon trash-cli
sudo pacman -S --needed --noconfirm nnn unarchiver atool zip unzip nsxiv zathura
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
