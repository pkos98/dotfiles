source ~/.zshenv.secret
export EDITOR=nvim
export BROWSER=firefox
export ZSH_DISABLE_COMPFIX=true
export DOTNET_ROOT="/opt/dotnet"
export HEADSET="4C:87:5D:53:7E:90"
export HEADSET_JBL="B8:69:C2:59:3F:6A"
#export ANDROID_HOME="/home/pkos98/android"
#export PATH="$PATH:$ANDROID_HOME/android-studio/bin"
#export PATH="$PATH:$ANDROID_HOME/tools"
#export PATH="$PATH:$ANDROID_HOME/tools/bin"
#export PATH="$PATH:$ANDROID_HOME/platform-tools"
#export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.local/bin"
export QT_QPA_PLATFORMTHEME="gtk2"
#export AWT_TOOLKIT=MToolkit # for better java guis, see here:https://wiki.archlinux.org/index.php/Java#IntelliJ_IDEA
export DOTNET_CLI_TELEMETRY_OPTOUT=1 # disable .net core telemetry
export DOTNET_ROOT=/usr/share/dotnet
export MSBuildSDKsPath="/usr/share/dotnet/sdk/3.1.108/Sdks"
export ERL_AFLAGS="-kernel shell_history enabled" # saves iex history
export WINIT_X11_SCALE_FACTOR=1
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
#"qt5ct"
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
alias vim="nvim"
alias vi="nvim"
alias xclip="xclip -selection clipboard"
alias wclip=wl-copy
alias find="fd"
alias mnthdd="sudo mount openwrt_router:/ /mnt/hdd"
alias ccsi="chicken-csi"
alias ssh="export TERM=xterm-color; ssh"
alias tf="terraform"
alias findcontent="grep -rnw './' -e "
# for sway
#export XKB_DEFAULT_LAYOUT=de
#export _JAVA_AWT_WM_NONREPARENTING=1
alias dc="sudo -E docker-compose"
