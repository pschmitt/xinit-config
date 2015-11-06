############################################################
# File:     xinitrc   Xorg init config file                #
# URL:      https://github.com/pschmitt/xinit#config       #
# Version:  1.3                                            #
# Author:   Philipp Schmitt <philipp@schmitt.co>           #
############################################################
#                 _       _ _
#           __  _(_)_ __ (_) |_ _ __ ___
#           \ \/ / | '_ \| | __| '__/ __|
#            >  <| | | | | | |_| | | (__
#           /_/\_\_|_| |_|_|\__|_|  \___|
#

# From /etc/skel/.xinitrc
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Start a D-Bus session
# source /etc/X11/xinit/xinitrc.d/30-dbus
# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
# You probably need to do this too:
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

# Variables
XLOGFILE=/var/log/xinitrc.log

############
#    WM    #
############
[[ $1 == "awesome" || $1 == "dwm" || $1 == "wmii" ]] && SESSION=$1 || SESSION="xmonad"
#$SESSION &> XLOGFILE & wmpid=$!
$SESSION & wmpid=$!

############
#  SYSTEM  #
############
stalonetray &
spacefm -d &
(
    urxvtd -q -o -f
    # TODO: Use a systemd service instead
    xrdb -merge $HOME/.config/Xresources/Xresources
    urxvtc -name "tmux" -e $SHELL -c "tmux -2u attach"
) &
nitrogen --restore &

############
#    IO    #
############
xmodmap $HOME/.config/xmodmap/xmodmaprc &
xsetroot -cursor_name left_ptr &
sxhkd &
unclutter &
# enable mouse keys
# alternative: /etc/X11/xorg.conf.d/20-enable-pointerkeys.conf
# setxkbmap -option keypad:pointerkeys &

############
#  SOUND   #
############
start-pulseaudio-x11 &
volnoti &

############
# NETWORK  #
############
${BROWSER}-fullscreenhack || $BROWSER &

#################
# HOST SPECIFIC #
#################
MYXINITRC="$HOME/.config/xinit/xinitrc_$(hostname)"
[[ -r $MYXINITRC ]] && . $MYXINITRC &

# wait for wm
wait $wmpid

# vim:ft=sh ff=unix et ts=4
