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
            if [ $2 ]; then
                SUBTITLES="$2"
            else
                SUBTITLES=0 # set default to 0
            fi
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
        echo "[Debug] $1"
    fi
}

PROCESS_PATH=processing

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
    command="./ffmpeg -i $PROCESS_PATH/$i "
    debug "set command: ./ffmpeg -i $PROCESS_PATH/$i "
    if [ $SIZE ] && [ $SUBTITLES ]; then
        command+="-vf scale=-2:$SIZE,subtitles=$PROCESS_PATH/$i:si=$SUBTITLES "
        debug "set command: -vf scale=-2:$SIZE,subtitles=$PROCESS_PATH/$i:si=$SUBTITLES "
    else
        if [ $SIZE ]; then
            command+="-vf scale=-2:$SIZE "
            debug "set command: -vf scale=-2:$SIZE "
        fi
        if [ $SUBTITLES ]; then
            command+="-vf subtitles=$PROCESS_PATH/$i:si=$SUBTITLES "
            debug "set command: -vf subtitles=$PROCESS_PATH/$i:si=$SUBTITLES "
        fi
    fi
    command+="$OUTPUT_PATH/$output"
    debug "set command: $OUTPUT_PATH/$output"

    /bin/mv "$i" "$PROCESS_PATH/$i"
    debug "move $i to $PROCESS_PATH/$i"
    output="${i/mkv/mp4}"
    debug "set out name to $output"
    $command
    debug "run command"
    /bin/mv "$PROCESS_PATH/$i" "$OUTPUT_PATH/$i"
    debug "move $PROCESS_PATH/$i to $OUTPUT_PATH/$i"
done
