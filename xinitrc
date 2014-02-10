#!/bin/zsh

# From /etc/skel/.xinitrc
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Start a D-Bus session
#source /etc/X11/xinit/xinitrc.d/30-dbus
# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
# You probably need to do this too:
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

# Variables
XLOGFILE=/var/log/xinitrc.log

# Helper
run_once () {
    pgrep $1 > /dev/null || ($@ &)
}

# Alternative methods for run_once
# if ! pidof $1 > /dev/null; then # alternative 2
#    $@
# fi
# if [ -z "`ps -Af | grep -o -w ".*$1" | grep -v grep | grep -v run-once`" ]; then
#    $@
# fi


############
#    WM    #
############
[[ $1 == "awesome" || $1 == "dwm" || $1 == "wmii" ]] && SESSION=$1 || SESSION="xmonad"
#$SESSION &> XLOGFILE & wmpid=$!
$SESSION & wmpid=$!
#$SESSION & wmpid=$!
#~/bin/xrdr &


############
#  SYSTEM  #
############
stalonetray &
spacefm -d &
xrdb -merge $HOME/.config/Xresources/Xresources &
run_once unclutter &
run_once urxvtd -q -o -f &
sleep 5 && urxvtc -name "tmux" -e zsh -c "tmux -2u attach" &
nitrogen --restore &
#xscreensaver -no-splash &
#sleep 3 && xscreensaver-command -lock &
#synergys &


############
#    IO    #
############
xmodmap $HOME/.config/xmodmap/xmodmaprc &
xsetroot -cursor_name left_ptr &
xbindkeys -f $HOME/.config/xbindkeys/xbindkeysrc &
# setxkbmap -option keypad:pointerkeys & # enable mouse keys (alternative: /etc/X11/xorg.conf.d/20-enable-pointerkeys.conf)

############
#  SOUND   #
############
start-pulseaudio-x11 &
volnoti &

############
# NETWORK  #
############
${BROWSER}-fullscreenhack &
#sleep 30 && run_once offlineimap &


############
#    DL    #
############
# amule &
# jdownloader &


############
#   MISC   #
############
#remind -z1 '-kgxmessage -center -wrap %s &' ~/.remind/.reminders &


#################
# HOST SPECIFIC #
#################
MYXINITRC="$HOME/.config/xinit/xinitrc_$(hostname)"
[[ -x $MYXINITRC ]] && $MYXINITRC &

# wait for wm
wait $wmpid

