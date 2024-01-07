source /home/${USER}/.zshenv.secret

export EDITOR=nvim
export VISUAL=nvim
export PATH="${PATH}:/home/pkos98/bin"
export ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=0 # disable
export ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=0
alias ..="cd .."
alias ...="cd .. && cd .."
alias vim=nvim
alias tf=terraform
alias ls="ls --color=auto"
alias cat="bat --paging=never" 
alias k=kubectl
alias kex="kubectl explain"
alias ssh="TERM=xterm-color; ssh"
alias gpt="chatgpt -i"
alias chat="chatgpt -i"
alias grep="grep --color"

function always() {
  while true; do $@; done
}
