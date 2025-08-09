#!/bin/bash

status=$(playerctl -p spotify status 2>/dev/null)

if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    artist=$(playerctl -p spotify metadata artist)
    title=$(playerctl -p spotify metadata title)
    arturl=$(playerctl -p spotify metadata mpris:artUrl)

    artist=$(echo "$artist" | sed 's/&/\&/g')
    title=$(echo "$title" | sed 's/&/\&/g')
    arturl=${arturl/https:/http:}  # waybar can't handle https images sometimes, icl

    echo "{\"text\": \"$artist - $title\", \"tooltip\": false, \"class\": \"custom-spotify\", \"alt\": \"Spotify\", \"image\": \"$arturl\"}"
else
    echo "{\"text\": \"Paused\", \"tooltip\": false, \"class\": \"custom-spotify\", \"alt\": \"Spotify (Paused)\"}"
fi
