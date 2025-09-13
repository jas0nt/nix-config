case $1 in
up)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+
    notify-send -r 1 -t 2000 -i volume "Vol: $(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
    ;;

down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
    notify-send -r 1 -t 2000 -i volume "Vol: $(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
    ;;

mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;

gui)
    pkill pwvucontrol || pwvucontrol
    ;;

*)
    notify-send -r 1 -t 2000 -i volume "Vol: $(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
    ;;
esac
