#!/bin/bash
PATH=finished

if [ ! -e $PATH ]; then
  /bin/mkdir $PATH
fi

for i in *.mkv
do
  ./ffmpeg -i $i -vf subtitles=$i $PATH/$i.mp4
  /bin/mv $i $PATH/$i
done
