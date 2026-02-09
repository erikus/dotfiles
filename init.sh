#!/bin/bash

cd ~

link() {
  local src="dotfiles/$1" dest=".$1"
  if [[ -L "$dest" ]]; then
    ln -sf "$src" "$dest"
  elif [[ -e "$dest" ]]; then
    echo "warning: ~/$dest already exists and is not a symlink, skipping" >&2
  else
    ln -s "$src" "$dest"
  fi
}

link zshrc
link zshenv
link zshrc.compat
link zshrc.special
link zshenv.special
link screenrc
link tmux.conf
link gitconfig
