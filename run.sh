#!/bin/bash
while [[ $# -gt 1 ]]
do
    key="$1"
    case $key in
        -s|--size)
        SIZE="$2"
        shift # past argument
        ;;
        -o|--output)
        OUTPUT="$2"
        shift # past argument
        ;;
        *)
        # unknown option
        ;;
    esac
    shift # past argument or value
done

PROCESS_PATH=processing

if [ $OUTPUT ]; then
    OUTPUT_PATH=$OUTPUT
else
    OUTPUT_PATH=finished
fi

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
    if [ $SIZE ]; then
        ./ffmpeg -i "$PROCESS_PATH/$i" -vf scale="-2:$SIZE",subtitles="$PROCESS_PATH/$i" "$OUTPUT_PATH/$output"
    else
        ./ffmpeg -i "$PROCESS_PATH/$i" -vf subtitles="$PROCESS_PATH/$i" "$OUTPUT_PATH/$output"
    fi
    /bin/mv "$PROCESS_PATH/$i" "$OUTPUT_PATH/$i"
done
