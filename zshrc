# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# where do you want to store your plugins?
ZPLUGINDIR=$HOME/.config/zsh/plugins
SAVEHIST=1000  # Save most-recent 1000 lines
HISTSIZE=1000
HISTFILE=~/.zsh_history

# get zsh_unplugged and store it with your other plugins
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi
source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.zsh

# make list of the Zsh plugins you use
repos=(
  #zdharma/fast-syntax-highlighting
  # other plugins
  #zsh-users/zsh-completions
  #zsh-users/zsh-syntax-highlighting
  z-shell/F-Sy-H
  zsh-users/zsh-history-substring-search
  # joshskidmore/zsh-fzf-history-search
)

# now load your plugins
plugin-load $repos
source $ZPLUGINDIR/dotenv.plugin.zsh
bindkey -v
export KEYTIMEOUT=1
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

autoload -U +X compinit && compinit
#source /usr/share/zsh/vendor-completions/kubectl.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.p10k.zsh
setopt HIST_IGNORE_ALL_DUPS

[[ $- == *i* ]] && source "/tmp/fzf/shell/completion.zsh" 2> /dev/null
source "${ZPLUGINDIR}/fzf-key-bindings.zsh"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

python_venv() {
  [[ -d "./.venv" ]] && source ./.venv/bin/activate > /dev/null 2>&1
}
autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv
