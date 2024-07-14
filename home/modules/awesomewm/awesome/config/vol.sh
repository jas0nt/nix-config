#!/usr/bin/env bash

mute=$(pulsemixer --get-mute)
vol=$(pulsemixer --get-volume | awk '{print $1}')
echo $mute $vol
