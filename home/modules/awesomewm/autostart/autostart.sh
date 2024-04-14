#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash

runOnce(){
    for cmd in "$@"
    do
        pgrep -u $USER -fx '$cmd' > /dev/null || $cmd &
    done
}

runOnce picom fcitx5 nm-applet

pgrep 'pasystray' > /dev/null || pasystray &
pgrep 'firefox' > /dev/null || firefox &

