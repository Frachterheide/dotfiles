#!/bin/zsh
set -e;

if pgrep brave >/dev/null; then echo "Shutting down Brave..." && swaymsg "[class=\"Brave-browser\"] kill"; fi
if pgrep foot >/dev/null; then echo "Shutting down foot..." && swaymsg "[app_id=\"foot\"] kill"; fi
if pgrep idea >/dev/null; then echo "Shutting down IntelliJ..." && swaymsg "[class=\"jetbrains-idea-ce\"] kill"; fi
if pgrep tmux >/dev/null; then echo "Shutting down Tmux..." && swaymsg "[class=\"tmux\"] kill"; fi
if pgrep firefox >/dev/null; then echo "Shutting down Firefox..." && swaymsg "[class=\"firefox\"]"; fi
if pgrep spotify >/dev/null; then echo "Shutting down Spotify..." && swaymsg "[class=\"Spotify\"] kill"; fi
if pgrep thunderbird >/dev/null; then echo "Shutting down Thunderbird..." && swaymsg "[class=\"thunderbird\"] kill"; fi
