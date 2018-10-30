source /home/patrick/.zshenv.secret
export EDITOR=vim
export BROWSER=firefox
export LANG="de_DE.UTF-8"
export ZSH_DISABLE_COMPFIX=true
export PATH="$PATH:/opt/miniconda3/bin"
export ANDROID_HOME="/home/patrick/android"
export PATH="$PATH:$ANDROID_HOME/android-studio/bin"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
alias statusctl="sudo systemctl status "
alias startctl="sudo systemctl start "
alias stopctl="sudo systemctl stop "
alias enablectl="sudo systemctl enable "
alias disablectl="sudo systemctl disable "
alias sd="sudo shutdown now"
alias rb="sudo reboot now"
alias xop="xdg-open"
alias sshnas="ssh root@192.168.0.101"
alias -g "kbd_backlight"="/bin/bash /usr/local/share/kbd_backlight"
alias sysctl="sudo systemctl"
alias vi="vim"
alias xclip="xclip -selection clipboard"
# for sway
#export XKB_DEFAULT_LAYOUT=de
#export _JAVA_AWT_WM_NONREPARENTING=1
