if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]
then
        startx
fi
#if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#  XKB_DEFAULT_LAYOUT=de exec sway
#fi

