#!/bin/sh

if ! pgrep foot >/dev/null; then echo "Launching foot..." && swaymsg "exec /usr/bin/foot"; fi
if [ $(pgrep tmux | wc -l) -lt 1 ]; then echo "Launching foot 2..." && swaymsg "exec /usr/bin/foot --app-id tmuxed_foot"; fi
if ! pgrep firefox >/dev/null; then echo "Launching Firefox..." && swaymsg "exec /usr/bin/firefox"; fi
if ! pgrep thunderbird >/dev/null; then echo "Launching Thunderbird..." && swaymsg "exec /usr/bin/thunderbird"; fi
