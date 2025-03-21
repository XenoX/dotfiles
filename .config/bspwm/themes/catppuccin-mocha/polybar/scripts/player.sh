#!/usr/bin/env bash

player_status=$(playerctl --player=tidal-hifi,spotify,%any status 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo -e " $(playerctl --player=tidal-hifi,spotify,%any metadata --format '{{ artist }} - {{ title }}')"
elif [ "$player_status" = "Paused" ]; then
    echo -e " $(playerctl --player=tidal-hifi,spotify,%any metadata --format '{{ artist }} - {{ title }}')"
else
	echo -e " No music!"
fi