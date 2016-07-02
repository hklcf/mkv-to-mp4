#!/bin/bash
PATH=finished

for i in *.mkv
do
  ./ffmpeg -i $i -vf subtitles=$i $PATH/$i.mp4
  mv $i $PATH/$i
done
