#!/bin/zsh
set -e;

if pgrep Alacritty >/dev/null; then echo "Shutting down Alacritty..." && swaymsg "[app_id=\"Alacritty\"] kill"; fi
if pgrep idea >/dev/null; then echo "Shutting down IntelliJ..." && swaymsg "[class=\"jetbrains-idea-ce\"] kill"; fi
if pgrep tmux >/dev/null; then echo "Shutting down Tmux..." && swaymsg "[class=\"tmux\"] kill"; fi
if pgrep firefox >/dev/null; then echo "Shutting down Firefox..." && swaymsg "[class=\"firefox\"]"; fi
if pgrep spotify >/dev/null; then echo "Shutting down Spotify..." && swaymsg "[class=\"Spotify\"] kill"; fi
if pgrep thunderbird >/dev/null; then echo "Shutting down Thunderbird..." && swaymsg "[class=\"thunderbird\"] kill"; fi
