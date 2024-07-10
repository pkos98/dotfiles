# vi: ft=bash
export EDITOR=nvim
export VISUAL=nvim
export PATH="${PATH}:$HOME/bin:$HOME/.local/bin"
export ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=0 # disable
export ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=0
export SHELL=/usr/bin/zsh
export TERM=xterm-256color
alias ..="cd .."
alias ...="cd .. && cd .."
alias vim=nvim
alias tf=terraform
alias ls="ls --color=auto"
alias cat="bat --paging=never"
alias ccat=/bin/cat
alias k=kubectl
alias kex="kubectl explain"
alias ssh="TERM=xterm-color; ssh"
alias gpt="chatgpt -i"
alias chat="chatgpt -i"
alias grep="grep --color"
alias vimm="(cd ~/src/dotfiles/ && nvim config/nvim/init.lua)"
alias cdn="cd ~/.config/nvim"
alias lg=lazygit
alias nvimdiff="nvim -d"
alias vimdiff="nvim -d"
alias pip="uv pip"
alias pipx="pipxu"
alias z="zoxide"
source ~/.zshenv.secret

function always() {
	while true; do $@; done
}

function hey() {
	if [ "${1}" = "chat" ]; then
		llm chat -o temperature 0.4
	else
		llm -o temperature 0.4 "${@}"
	fi
}

function gs() {
  msg="${1}"
  if [ "${msg}" = "" ]; then msg=$(date "+%a %d.%m.%y %H:%M"); fi
  git stash push --include-untracked --message "$(git branch | tail -c +3): ${msg}"
}
