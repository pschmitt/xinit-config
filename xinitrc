#!/bin/zsh -f

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
[[ $1 == "awesome" || $1 == "dwm" || $1 == "wmii" ]] && SESSION=$1 || SESSION="xmonad" #SESSION="awesome" SESSION="i3 -V" 
#ck-launch-session dbus-launch --exit-with-session
$SESSION &> XLOGFILE & wmpid=$!
~/bin/xrdr &


############
#  SYSTEM  #
############
spacefm -d &
#sh ~/.fehbg & # now set by xrdr
xrdb -merge $XDG_CONFIG_HOME/Xresources/Xresources &
run_once unclutter &
run_once urxvtd -q -o -f &
#xscreensaver -no-splash &
#sleep 3 && xscreensaver-command -lock &
urxvtc -name "tmux" -e zsh -c "tmux -2u attach" &
#synergys &


############
#    IO    #
############
#numlockx & 
if [[ "$HOST" == "LaXLinux-CL" ]]; then
    synclient EmulateTwoFingerMinW=7 &
    synclient EmulateTwoFingerMinZ=20 &
#    synclient VertTwoFingerScroll=1 &
    synclient HorizTwoFingerScroll=1 &
    # syndaemon -i 2 & # Prevent mouse from clicking while typing (for 2sec)
    xbacklight -display :0 -set 100 &
    xautolock -locker "i3lock -b -i /home/pschmitt/pictures/wallpapers/me\ gusta\ mucho_1366.png" -time 3 &
else
    numlockx &
    irexec -d &
fi
xmodmap $XDG_CONFIG_HOME/xmodmap/xmodmaprc &
xsetroot -cursor_name left_ptr &
# setxkbmap -option keypad:pointerkeys & # enable mouse keys (alternative: /etc/X11/xorg.conf.d/20-enable-pointerkeys.conf)
xbindkeys -f $XDG_CONFIG_HOME/xbindkeys/xbindkeysrc &

############
#  SOUND   #
############
#run_once mpd ~/.mpd/mpd.conf &
#run_once mpdscribble &


############
# NETWORK  #
############
LD_PRELOAD=/usr/lib/libfullscreenhack.so $BROWSER &
if [[ "$HOST" == "LaXLinux" ]]; then
    stalonetray &
    trickle -u 40 google-musicmanager &
    android-notifier-desktop &
fi
#sleep 30 && run_once offlineimap &


############
#    DL    #
############
# amule &
# jdownloader &



############
#  STUFF   #
############
remind -z1 '-kgxmessage -center -wrap %s &' ~/.remind/.reminders &


# wait for wm
wait $wmpid

