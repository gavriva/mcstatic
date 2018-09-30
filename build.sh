#!/bin/sh -e

VERSION=4.8.21

archive_name=${VERSION}.tar.gz

echo "Download Midnight Commander ${VERSION}"

cd /mc-build

rm -rf mc-src mc-bin mc.run tmp
mkdir mc-src tmp
cd tmp
wget https://github.com/MidnightCommander/mc/archive/${archive_name}
cd -
tar xf tmp/${archive_name}  --strip-components=1 -C mc-src

echo "Install dependencies"

apk update
apk add --no-cache gcc git ruby patch musl-dev make libtool autoconf automake glib-dev glib-static slang-dev libssh2-dev

cd tmp
wget https://github.com/probonopd/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
cd -

echo "Apply patches"

for f in patches/*.patch ; do
    patch -p0 -t -d mc-src <$f
done

echo "Build static mc"

bin_dst=`pwd`/mc-bin

cd mc-src

./autogen.sh

LDFLAGS='--static -Wl,-static' LIBS='-lc -lglib-2.0 -lpcre -lssh2 -lcrypto -lz -lintl' GLIB_LIBDIR=/usr/lib ./configure --without-gpm-mouse --without-x --with-screen=slang --disable-nls --disable-rpath --disable-vfs-fish --prefix=/mc-build/mc-bin --with-glib-static --disable-shared --enable-static --disable-doxygen-doc
make install

cd -
cp files/* mc-bin

echo "Fix paths"

ruby fix_paths.rb
#./tmp/appimagetool-x86_64.AppImage -v mc-bin mc.run
#rm -rf tmp mc-bin mc-src
