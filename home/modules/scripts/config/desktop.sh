set -x

DIR=$(dirname "$0")

case $1 in

monitor)
    pkill btop || $TERMINAL --class myfloatingl btop
    ;;

launcher)
    $TERMINAL --class myfloating sway-launcher-desktop
    ;;

idle-lock)
    source $DIR/utils.sh
    if is-media-playing; then
        echo "Not locking"
        wlrctl pointer move 1
        wlrctl pointer move -1
    else
        echo "Locking"
        hyprctl dispatch workspace empty
        hyprlock
    fi
    ;;

logout-menu)
    pkill wlogout || wlogout -b 5 -B 500 -T 500
    ;;

lock)
    hyprlock
    ;;

logout)
    hyprctl dispatch exit
    ;;

hibernate)
    systemctl hibernate
    ;;

reboot)
    systemctl reboot
    ;;

shutdown)
    shutdown -h now
    ;;

file-manager)
    $TERMINAL --class fm ranger
    ;;

screenshot)
    grim -g "$(slurp)" - | wl-copy
    ;;

calendar)
    pkill calcure || $TERMINAL --class myfloating calcure
    ;;

notification-center)
    sleep 0.1s
    swaync-client -t -sw
    ;;

notification-dnd)
    swaync-client -d -sw
    ;;

*)
    echo Unknown: $0 $*
    ;;
esac
