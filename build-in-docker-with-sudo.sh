#!/bin/sh -e

user=`id -u -n`
group=`id -g -n`

sudo docker run -v `pwd`:/mc-build --security-opt="apparmor=unconfined" --cap-add=SYS_PTRACE -it alpine sh -e /mc-build/build.sh

sudo chown ${user}:${group} -R tmp mc-bin mc-src

echo "Make AppImage: mc.run"

./tmp/appimagetool-x86_64.AppImage -v mc-bin mc.run
rm -rf tmp mc-bin mc-src
