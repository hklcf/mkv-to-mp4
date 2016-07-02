#!/bin/bash
PATH=finished

if [ ! -e $PATH ]; then
  mkdir $PATH
fi

for i in *.mkv
do
  ./ffmpeg -i $i -vf subtitles=$i $PATH/$i.mp4
  mv $i $PATH/$i
done
