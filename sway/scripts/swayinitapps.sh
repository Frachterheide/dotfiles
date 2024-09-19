#!/bin/sh

if ! pgrep alacritty >/dev/null; then echo "Launching Alacritty..." && swaymsg "exec /usr/bin/alacritty"; fi
if [ $(pgrep tmux | wc -l) -lt 1 ]; then echo "Launching Tmux..." && swaymsg "exec /usr/bin/alacritty --class tmuxed_crit -e /usr/bin/tmux"; fi
if ! pgrep firefox >/dev/null; then echo "Launching Firefox..." && swaymsg "exec /usr/bin/firefox"; fi
