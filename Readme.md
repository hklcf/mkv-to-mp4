# mkv-to-mp4
[`mkv-to-mp4`](https://github.com/hklcf/mkv-to-mp4) is a shell script to convert your mkv file to mp4. If you are unable to run this script with `./run.sh` then you probably need to set it's permissions.

*You can do this by typing the following:*

```sh
chmod 755 run.sh
```

after this has been done, you can type `./run.sh` to run the script.

### Requirement
- Linux (32bit / 64bit)

This script tested on Debian 7 only.

### General Usage
```
usage: run.sh [-s SIZE] [-o OUTPUT]

optional arguments:
  -s SIZE, --size SIZE
                          Set resolution of the video. (Default same as original)
  -o OUTPUT, --output OUTPUT
                          Set output file path. (Default: finished)
```

### Example
```sh
./run.sh -s 480
```

This will convert the mkv to a 480p mp4 file.
