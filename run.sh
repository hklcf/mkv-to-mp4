#!/bin/bash
PATH=finished

if [ ! -e $PATH ]; then
  /bin/mkdir $PATH
fi

for i in *.mkv
do
  output="${i/mkv/mp4}"
  ./ffmpeg -i $i -vf subtitles=$i $PATH/$output
  /bin/mv $i $PATH/$i
done
