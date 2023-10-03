#!/bin/bash

#Call This Script with a single video file as argument or a directory with multiple video files

ARGUMENT=$1

extract_sub() {

    VIDEO_FILE="$1"
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
    done <<<"$SUBTITLE_INFO"
}

# Checking if the input is provided
if [[ -z $ARGUMENT ]]; then
    echo "Usage: $0 <video-file>  OR <Directory>"
    exit 1
fi

create_subs_dir() {
    # Creating a sub directory to store the subtitles if it doesn't exist
    if [ ! -d subs ]; then
        mkdir -p subs
    fi
}

if [[ -d $ARGUMENT ]]; then
    #Argument is a directory
    echo "Input is a directory"
    cd "$ARGUMENT"
    create_subs_dir
    for f in "$ARGUMENT"/*; do
        #Only execute when f is an File
        if [[ -f $f ]]; then
            extract_sub "$f"
        fi
    done

elif
    [[ -f $ARGUMENT ]]
then
    #Argument is a file
    echo "Input is a file"
    create_subs_dir
    extract_sub "$ARGUMENT"

else
    echo "$ARGUMENT is not valid"
    exit 1
fi
