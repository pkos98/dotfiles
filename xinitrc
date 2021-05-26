#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xset +dpms # enable auto-standby of the monitor [redundant as setting dpms values implicitly enables dpms]
xset 0 240 # lock screen after 240 seconds. NOTE: standby=suspend on this monitor
msg_txt="Architect is going to lock due to inactivity"
xss-lock -n "notify-send -t 3000 -i notification-display-brightness Autolock '$msg_txt'" i3lock-fancy &
urxvtd -q -o -f
wmname i3 # must be executed before i3, compiz is executed within i3rc
exec i3
