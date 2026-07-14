#!/usr/bin/env zsh
# vi: ft=bash

# Ensure path arrays do not contain duplicates.
typeset -gU path cdpath fpath mailpath

# Set PATH using zsh array syntax
path=(
  $HOME/.local/share/mise/shims
  $HOME/bin
  $HOME/.local/bin
  $HOME/.cargo/bin
  /opt/homebrew/opt/rustup/bin
  $HOME/.bun/bin
  $HOME/go/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  $path
)

export EDITOR=nvim
export VISUAL=nvim
export SHELL=/bin/zsh
export TERM=xterm-256color
export DISABLE_AUTO_TITLE="true"
export DS_ID="2701253820"
export ERL_AFLAGS="-kernel shell_history enabled"
export ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=0 # disable
export ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=0

source ~/.zshenv.secret
