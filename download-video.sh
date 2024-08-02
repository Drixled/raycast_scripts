#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title yt-dlp
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 💾
# @raycast.argument1 { "type": "text", "placeholder": "URL to Download" }

# Documentation:
# @raycast.author user_d33fbc6952a431413f06
# @raycast.authorURL https://raycast.com/user_d33fbc6952a431413f06

show_hud() {
    osascript -e "display notification \"$1\" with title \"Raycast\""
}

url=$(pbpaste)
if [ -z "$url" ]; then
    show_hud "No URL found in clipboard"
    exit 1
fi

output_dir="$HOME/Downloads"
mkdir -p "$output_dir"

title=$(yt-dlp --get-title "$url" 2>/dev/null)
if [ -z "$title" ]; then
    show_hud "Failed to retrieve video title"
    exit 1
fi

sanitized_title=$(echo "$title" | tr -cd '[:alnum:]._-')
output_path="$output_dir/${sanitized_title}.mp4"

if yt-dlp -o "$output_path" "$url"; then
    # Copy the file to the clipboard using AppleScript
    osascript -e "set the clipboard to POSIX file \"$output_path\""
    show_hud "Video downloaded and copied to clipboard!"
else
    show_hud "Error downloading video"
    exit 1
fi
