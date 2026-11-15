#!/usr/bin/env bash

case $1 in

monitor)
    pkill btop || $TERMINAL --class myfloatingl btop
    ;;

launcher)
    fuzzel
    ;;

logout-menu)
    pkill wlogout || wlogout -b "$(wc -l < "$HOME/.config/wlogout/layout")" -B 700 -T 700
    ;;

lock)
    hyprlock
    ;;

logout)
    niri msg action quit
    ;;

reboot)
    systemctl reboot
    ;;

shutdown)
    systemctl poweroff
    ;;

toggle-im)
    fcitx5-remote -t
    ;;

network-manager)
    pkill impala || $TERMINAL --class myfloatingm impala
    ;;

file-manager)
    $TERMINAL --class fm yazi
    ;;

record)
    RECORDING_DIR=~/Videos/Recording
    FILENAME="$(date +'%Y-%m-%d_%H-%M-%S').mp4"
    RECORDING_FILE=$RECORDING_DIR/$FILENAME
    mkdir -p $RECORDING_DIR
    pkill wf-recorder || (wf-recorder --audio --audio-backend=pipewire -g "$(slurp)" -f $RECORDING_FILE && notify-send -i camera "Recording saved $RECORDING_FILE")
    ;;

record-screen)
    RECORDING_DIR=~/Videos/Recording
    FILE_DATE="$(date +'%Y-%m-%d_%H-%M-%S')"
    RECORDING_FILE=$RECORDING_DIR/$FILE_DATE.mp4
    mkdir -p $RECORDING_DIR
    pkill wf-recorder || (wf-recorder --audio --audio-backend=pipewire -f $RECORDING_FILE)
    ;;

calendar)
    pkill calcure || $TERMINAL --class myfloatingm calcure
    ;;

notification-center)
    sleep 0.1s
    makoctl restore
    ;;

*)
    echo Unknown: $0 $*
    ;;
esac
