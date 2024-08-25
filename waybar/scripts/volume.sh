#!/usr/bin/zsh

case "$1" in
    'up')
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    'down')
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    'mute')
        sink=($(pactl list short sinks | grep RUNNING | cut -f1 | tr '/n' ' '))
        for i in $sink[@]
        do
            pactl set-sink-mute $i toggle
        done
        ;;
    *)
        echo $"Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac
