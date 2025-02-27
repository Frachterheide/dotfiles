#!/bin/sh

if ! pgrep wezterm >/dev/null; then echo "Launching Wezterm..." && swaymsg "exec /usr/bin/wezterm"; fi
if [ $(pgrep tmux | wc -l) -lt 1 ]; then echo "Launching Tmux..." && swaymsg "exec /usr/bin/wezterm -e --class tmuxed_term /usr/bin/tmux"; fi
if ! pgrep firefox >/dev/null; then echo "Launching Firefox..." && swaymsg "exec /usr/bin/firefox"; fi
if ! pgrep librewolf >/dev/null; then echo "Launching Librewolf..." && swaymsg "exec /usr/bin/librewolf"; fi
