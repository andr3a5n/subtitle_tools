#!/bin/bash

# Checking if the input file is provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 <video-file>"
    exit 1
fi

VIDEO_FILE="$1"

# Creating a sub directory to store the subtitles if it doesn't exist
if [ ! -d subs ]; then
  mkdir -p subs
fi

# Getting the list of subtitle tracks
SUBTITLE_INFO=$(mkvmerge -i "$VIDEO_FILE" | grep 'subtitles')

echo "SUBTITLE_INFO:"
echo "$SUBTITLE_INFO"
# Extracting each subtitle track
while IFS= read -r line; do
    # Getting track number
    TRACK_NUMBER=$(echo "$line" | awk -F: '{print $1}' | awk '{print $3}')
    
    #echo "TRACK_NUMBER: $TRACK_NUMBER"   
   
    #echo "TRACK_LANG: $TRACK_LANG"
    
    # Assuming the format is srt as it's a common format, adjust as necessary
    TRACK_FORMAT="srt"
    
    #echo "TRACK_FORMAT: $TRACK_FORMAT"
    
    # Creating the file name for the subtitle track
    SUBTITLE_FILE="subs/$(basename "$VIDEO_FILE" .mkv)_${TRACK_NUMBER}.${TRACK_FORMAT}"
    
    #echo "SUBTITLE_FILE: $SUBTITLE_FILE"
    
    # Extracting the subtitle track
    mkvextract tracks "$VIDEO_FILE" ${TRACK_NUMBER}:${SUBTITLE_FILE}
done <<< "$SUBTITLE_INFO"

