case $1 in
up)
    pulsemixer --change-volume +1
    notify-send -r 1 -t 2000 -i volume "Vol: $(pulsemixer --get-volume)"
    ;;

down)
    pulsemixer --change-volume -1
    notify-send -r 1 -t 2000 -i volume "Vol: $(pulsemixer --get-volume)"
    ;;

mute)
    pulsemixer --toggle-mute
    ;;

gui)
    pkill pavucontrol || pavucontrol
    ;;

tui)
    pkill pulsemixer || $TERMINAL --class myfloating pulsemixer
    ;;

*)
    notify-send -r 1 -t 2000 -i volume "Vol: $(pulsemixer --get-volume)"
    ;;
esac
