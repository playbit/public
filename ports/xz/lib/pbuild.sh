# liblzma library
# https://tukaani.org/xz/
#
#!BUILDTOOL toolchain
#!BUILDTOOL ports/curl if HERMETIC
#
#!DEP ports/libc [transitive]
#
source /p/tools/pbuild.lib.sh

# Note: when upgrading, don't forget to also update ../pbuild.sh
VERSION=5.6.2
pbuild_fetch_and_unpack \
    https://tukaani.org/xz/xz-$VERSION.tar.xz \
    a9db3bb3d64e248a0fae963f8fb6ba851a26ba1822e504dc0efd18a80c626caf

pbuild_apply_patches

pbuild_configure_once ./configure \
    --host=$CHOST \
    --prefix=/usr \
    --datadir=/usr/share \
    --bindir=/bin \
    --libdir=/lib \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --disable-shared \
    --enable-static \
    --enable-threads=yes \
    --disable-rpath \
    --disable-werror \
    --disable-doc \
    --disable-nls \
    --enable-sandbox=landlock \
    \
    --disable-lzmadec \
    --disable-lzmainfo \
    --disable-lzma-links \
    \
    --disable-xz \
    --disable-xzdec \
    --disable-scripts \

make -C src/liblzma -j$MAXJOBS DESTDIR=$DESTDIR install
