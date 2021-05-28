#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="nanotech"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  history-substring-search
  fast-syntax-highlighting
)

# Needs to be executed before sourcing
# Allows root to use autocomplete
export ZSH_DISABLE_COMPFIX=true
# .zshrc.pre-oh-my-zsh
# Lines configured by zsh-newuser-ifnstall
HISTFILE=~/.histfile
HISTSIZE=250
SAVEHIST=250
setopt autocd
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/pkos98/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall
zstyle ':completion:*' menu select

dl()
{ 
        curl -o "$1" "https://pkos98.dev/storage/$1"
}

ul() {
    curl -F "data=@${1}" https://pkos98.dev/storage
}

init_nvm() {
    source /usr/share/nvm/init-nvm.sh
}
