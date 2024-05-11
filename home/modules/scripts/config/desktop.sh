case $1 in

monitor)
    pkill btop || $TERMINAL --class myfloatingl btop
    ;;

launcher)
    $TERMINAL --class myfloating sway-launcher-desktop
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
    systemctl poweroff
    ;;

file-manager)
    $TERMINAL --class fm ranger
    ;;

screenshot)
    grimblast copysave area
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
