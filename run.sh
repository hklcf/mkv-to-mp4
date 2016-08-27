#!/bin/bash
for j in "$@"
do
    case $j in
        -s=*|--size=*)
        SIZE="${j#*=}"
        ;;
        *)
        # unknown option
        ;;
    esac
done

PROCESS_PATH=processing
OUTPUT_PATH=finished

if [ ! -e $PROCESS_PATH ]; then
    /bin/mkdir $PROCESS_PATH
fi

if [ ! -e $OUTPUT_PATH ]; then
    /bin/mkdir $OUTPUT_PATH
fi

for i in *.mkv
do
    /bin/mv "$i" "$PROCESS_PATH/$i"
    output="${i/mkv/mp4}"
    #./ffmpeg -i "$PROCESS_PATH/$i" -vf subtitles="$PROCESS_PATH/$i" "$OUTPUT_PATH/$output"
    if [ $SIZE ]; then
        ./ffmpeg -i "$PROCESS_PATH/$i" -vf scale="-2:$SIZE" subtitles="$PROCESS_PATH/$i" "$OUTPUT_PATH/$output"
    else
        ./ffmpeg -i "$PROCESS_PATH/$i" -vf subtitles="$PROCESS_PATH/$i" "$OUTPUT_PATH/$output"
    fi
    /bin/mv "$PROCESS_PATH/$i" "$OUTPUT_PATH/$i"
done
