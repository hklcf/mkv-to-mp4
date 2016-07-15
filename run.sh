#!/bin/bash
PROCESS_PATH=processing
OUTPUT_PATH=finished

if [ ! -e $PROCESS_PATH ]; then
  /bin/mkdir $PROCESS_PATH
fi

if [ ! -e $OUTPUT_PATH ]; then
  /bin/mkdir $OUTPUT_PATH
fi

/bin/mv *.mkv $PROCESS_PATH

for i in $PROCESS_PATH/*.mkv
do
  output="${i/mkv/mp4}"
  ./ffmpeg -i $PROCESS_PATH/$i -vf subtitles=$PROCESS_PATH/$i $OUTPUT_PATH/$output
  /bin/mv $PROCESS_PATH/$i $OUTPUT_PATH/$i
done
