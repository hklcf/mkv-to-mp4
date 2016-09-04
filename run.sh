#!/bin/bash
while [[ $# -gt 0 ]]
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
        -st|--subtitles)
            SUBTITLES="$2"
            shift # past argument
            ;;
        --debug)
            DEBUG=YES
            shift # past argument
            ;;
        *)
            # unknown option
            echo "[Error] Unknow option: $key"
            exit 1
            ;;
    esac
    shift # past argument or value
done

function debug {
    if [ $DEBUG ]; then
        echo -e "[Debug] $1\n"
    fi
}

PROCESS_PATH=processing
FFMPEG=./ffmpeg

if [ $OUTPUT ]; then
    OUTPUT_PATH=$OUTPUT
    debug "set output path to $OUTPUT_PATH"
else
    OUTPUT_PATH=finished
    debug "set output path to $OUTPUT_PATH"
fi

if [ ! -e $PROCESS_PATH ]; then
    /bin/mkdir $PROCESS_PATH
    debug "mkdir $PROCESS_PATH"
fi

if [ ! -e $OUTPUT_PATH ]; then
    /bin/mkdir $OUTPUT_PATH
    debug "mkdir $OUTPUT_PATH"
fi

for i in *.mkv
do
    PROCESS_FILE=$PROCESS_PATH/$i
    /bin/mv "$i" "$PROCESS_FILE"
    debug "move $i to $PROCESS_FILE"
    output="${i/mkv/mp4}"
    debug "set output name to $output"
    OUTPUT_FILE=$OUTPUT_PATH/$output
    if [ $SIZE ] && [ $SUBTITLES ]; then
        command=$($FFMPEG -i "$PROCESS_FILE" -vf scale=-2:$SIZE,subtitles="$PROCESS_FILE":si=$SUBTITLES "$OUTPUT_FILE")
        debug "set command: $FFMPEG -i $PROCESS_FILE -vf scale=-2:$SIZE,subtitles=$PROCESS_FILE:si=$SUBTITLES $OUTPUT_FILE"
    else
        if [ $SIZE ]; then
            command=$($FFMPEG -i "$PROCESS_FILE" -vf scale=-2:$SIZE "$OUTPUT_FILE")
            debug "set command: $FFMPEG -i $PROCESS_FILE -vf scale=-2:$SIZE $OUTPUT_FILE"
        fi
        if [ $SUBTITLES ]; then
            command=$($FFMPEG -i "$PROCESS_FILE" -vf subtitles="$PROCESS_FILE":si=$SUBTITLES "$OUTPUT_FILE")
            debug "set command: $FFMPEG -i $PROCESS_FILE -vf subtitles=$PROCESS_FILE:si=$SUBTITLES $OUTPUT_FILE"
        fi
    fi
    $command
    debug "run $command"
    /bin/mv "$PROCESS_FILE" "$OUTPUT_PATH/$i"
    debug "move $PROCESS_FILE to $OUTPUT_PATH/$i"
done
