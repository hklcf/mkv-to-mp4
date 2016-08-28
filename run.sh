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
        --debug)
        DEBUG=YES
        shift # past argument
        ;;
        *)
        # unknown option
        ;;
    esac
    shift # past argument or value
done

function debug {
    if [ $DEBUG ]; then
        echo $1
    fi
}

PROCESS_PATH=processing

if [ $OUTPUT ]; then
    OUTPUT_PATH=$OUTPUT
    debug 'set output path to' $OUTPUT_PATH
else
    OUTPUT_PATH=finished
    debug 'set output path to' $OUTPUT_PATH
fi

if [ ! -e $PROCESS_PATH ]; then
    /bin/mkdir $PROCESS_PATH
    debug 'mkdir' $PROCESS_PATH
fi

if [ ! -e $OUTPUT_PATH ]; then
    /bin/mkdir $OUTPUT_PATH
    debug 'mkdir' $OUTPUT_PATH
fi

for i in *.mkv
do
    /bin/mv "$i" "$PROCESS_PATH/$i"
    debug 'move' $i 'to' $PROCESS_PATH/$i
    output="${i/mkv/mp4}"
    debug 'set out name to' $output
    if [ $SIZE ]; then
        ./ffmpeg -i "$PROCESS_PATH/$i" -vf scale="-2:$SIZE",subtitles="$PROCESS_PATH/$i" "$OUTPUT_PATH/$output"
        debug 'ffmpeg with size argument'
    else
        ./ffmpeg -i "$PROCESS_PATH/$i" -vf subtitles="$PROCESS_PATH/$i" "$OUTPUT_PATH/$output"
        debug 'ffmpeg default'
    fi
    /bin/mv "$PROCESS_PATH/$i" "$OUTPUT_PATH/$i"
    debug 'move' $PROCESS_PATH/$i 'to' $OUTPUT_PATH/$i
done
