# vi: ft=bash
export EDITOR=nvim
export VISUAL=nvim
export PATH="${PATH}:/home/pkos98/bin:/home/pkos98/.local/bin"
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
alias vimm="(cd ~/src/dotfiles/ && nvim ~/.config/nvim/init.lua)"
alias cdn="cd ~/.config/nvim"
alias lg=lazygit
alias nvimdiff="nvim -d"
alias vimdiff="nvim -d"
alias lllm="~/.local/bin/llm"
alias llmm="~/.local/bin/llm"

source ~/.zshenv.secret

function always() {
  while true; do $@; done
}

function llm() {
  local input="$*"
  ~/.local/bin/llm -s 'Answer as short and concise as possible' ${input} | glow
}

function llmo() {
  local input="$*"
  ~/.local/bin/llm prompt -m 4o "$input"
}
